import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/category.dart';
import 'package:inkora/services/mock_data_service.dart';
import 'package:inkora/screens/write/new_chapter_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewBookPage extends StatefulWidget {
  const NewBookPage({super.key});

  @override
  State<NewBookPage> createState() => _NewBookPageState();
}

class _NewBookPageState extends State<NewBookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedGenre = '';
  File? _coverImage;
  bool _isLoading = false;

  bool get _isFormValid => _titleController.text.isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() {
          _coverImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _createBook() {
    if (!_isFormValid) return;
    
    setState(() {
      _isLoading = true;
    });

    final dataService = Provider.of<MockDataService>(context, listen: false);
    
    // Create new book
    final newBook = Book(
      id: 0, // Will be assigned by the service
      title: _titleController.text,
      author: 'Your Name', // TODO: Get from user profile
      coverImage: 'assets/default_cover.png', // TODO: Upload and get URL
      description: _descriptionController.text,
      rating: 0.0,
      chapters: 0,
      status: 'Draft',
      publishedDate: null,
      categories: _selectedGenre.isNotEmpty
          ? [dataService.categories.firstWhere((c) => c.name == _selectedGenre)]
          : [],
    );
    
    dataService.addBook(newBook);
    
    setState(() {
      _isLoading = false;
    });
    
    // Get the ID of the newly created book
    final createdBook = dataService.books.firstWhere(
      (b) => b.title == _titleController.text,
      orElse: () => Book(
        id: 0,
        title: '',
        author: '',
        coverImage: '',
        description: '',
        rating: 0,
        chapters: 0,
        status: '',
      ),
    );
    
    if (createdBook.id != 0) {
      // Navigate to add chapter
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewChapterPage(bookId: createdBook.id),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('New Book'),
            actions: [
              _isLoading
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 30,
                      height: 30,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : TextButton(
                      onPressed: _isFormValid ? _createBook : null,
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: _isFormValid
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                      ),
                    ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 120,
                            height: 180,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              image: _coverImage != null
                                  ? DecorationImage(
                                      image: FileImage(_coverImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _coverImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image, size: 40, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add Cover',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap to choose book cover',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    'Title:',
                    _titleController,
                    'Book title',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    'Genre:',
                    _selectedGenre.isEmpty ? 'Select' : _selectedGenre,
                    dataService.categories.map((c) => c.name).toList(),
                    (value) {
                      setState(() {
                        _selectedGenre = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextAreaField(
                    'Description:',
                    _descriptionController,
                    'Book description',
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _isFormValid ? _createBook : null,
                      icon: const Icon(Icons.check),
                      label: const Text('Create Book'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    String placeholder, {
    bool required = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (required)
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: options.contains(value) ? value : null,
              hint: Text(value),
              isExpanded: true,
              underline: Container(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField(
    String label,
    TextEditingController controller,
    String placeholder,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: placeholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }
}

