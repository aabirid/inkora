import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/services/mock_data_service.dart';
import 'package:inkora/widgets/book_card.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditBooklistPage extends StatefulWidget {
  final Booklist booklist;

  const EditBooklistPage({super.key, required this.booklist});

  @override
  _EditBooklistPageState createState() => _EditBooklistPageState();
}

class _EditBooklistPageState extends State<EditBooklistPage> {
  late TextEditingController _titleController;
  late String _visibility;
  late List<Book> _books;
  bool _isLoading = false;
  File? _coverImage;
  String? _coverImagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.booklist.title);
    _visibility = widget.booklist.visibility;
    _books = List<Book>.from(widget.booklist.books ?? []);
    _coverImagePath = widget.booklist.coverImage;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _coverImage = File(image.path);
          _coverImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _removeBook(int index) {
    setState(() {
      _books.removeAt(index);
    });
  }

  void _saveChanges() {
    setState(() {
      _isLoading = true;
    });

    final dataService = Provider.of<MockDataService>(context, listen: false);

    final updatedBooklist = Booklist(
      id: widget.booklist.id,
      userId: widget.booklist.userId,
      title: _titleController.text,
      visibility: _visibility,
      creationDate: widget.booklist.creationDate,
      books: _books,
      likesCount: widget.booklist.likesCount,
      booksCount: _books.length,
    );

    dataService.updateBooklist(updatedBooklist);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booklist updated successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Booklist"),
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
                  onPressed: _saveChanges,
                  child: const Text('Save'),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
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
                          image: (_coverImage != null)
                              ? DecorationImage(
                                  image: FileImage(_coverImage!),
                                  fit: BoxFit.cover,
                                )
                              : (_coverImagePath != null &&
                                      _coverImagePath!.startsWith('assets/'))
                                  ? DecorationImage(
                                      image: AssetImage(_coverImagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: (_coverImage == null &&
                                (_coverImagePath == null ||
                                    !_coverImagePath!.startsWith('assets/')))
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image,
                                      size: 40, color: Colors.grey[400]),
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
                      'Tap to change cover',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title field
              _buildFormField('Title:', _titleController, 'Booklist title'),
              const SizedBox(height: 16),

              // Visibility toggle
              _buildVisibilityToggle(),
              const SizedBox(height: 24),

              // Books section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Books in this list',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '${_books.length} books',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Books list
              if (_books.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No books in this list',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add books to your list from the book details page',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Stack(
                      children: [
                        // The BookCard widget
                        BookCard(book: book),
                        // Delete button overlay
                        Positioned(
                          top: 40,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.grey, size: 25),
                              onPressed: () => _showRemoveBookConfirmation(
                                  context, index, book),
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveBookConfirmation(BuildContext context, int index, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Book'),
        content: Text(
            'Are you sure you want to remove "${book.title}" from this booklist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _removeBook(index);
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
      String label, TextEditingController controller, String placeholder) {
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
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityToggle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            'Visibility:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: SwitchListTile(
            title: Text(_visibility == 'Public' ? 'Public' : 'Private'),
            subtitle: Text(_visibility == 'Public'
                ? 'Anyone can see this booklist'
                : 'Only you can see this booklist'),
            value: _visibility == 'Public',
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setState(() {
                _visibility = value ? 'Public' : 'Private';
              });
            },
          ),
        ),
      ],
    );
  }
}
