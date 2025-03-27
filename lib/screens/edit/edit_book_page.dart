import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/chapter.dart';
import 'package:inkora/models/category.dart';
import 'package:inkora/services/mock_data_service.dart';
import 'package:inkora/screens/write/new_chapter_page.dart';
import 'package:inkora/screens/edit/edit_chapter_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditBookPage extends StatefulWidget {
  final int bookId;

  const EditBookPage({super.key, required this.bookId});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  List<String> _selectedGenres = [];
  String _selectedStatus = 'Ongoing';
  bool _isPublished = false;
  bool _isLoading = false;
  File? _coverImage;
  String? _coverImagePath;

  // Add a field to store the data service
  late MockDataService _dataService;

  // Update the initState method to store the data service
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    // Load book data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dataService = Provider.of<MockDataService>(context, listen: false);
      final book = _dataService.getBookById(widget.bookId);
      if (book != null && mounted) {
        _titleController.text = book.title;
        _descriptionController.text = book.description;
        _selectedStatus = book.status;
        _isPublished = book.publishedDate != null;
        _coverImagePath = book.coverImage;

        if (book.categories != null && book.categories!.isNotEmpty) {
          setState(() {
            _selectedGenres = book.categories!.map((c) => c.name).toList();
          });
        }
      }
    });
  }

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
          _coverImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _saveBook() {
    setState(() {
      _isLoading = true;
    });

    final dataService = Provider.of<MockDataService>(context, listen: false);
    final book = dataService.getBookById(widget.bookId);

    if (book != null) {
      final updatedBook = Book(
        id: book.id,
        title: _titleController.text,
        author: book.author,
        coverImage: _coverImagePath ?? book.coverImage,
        description: _descriptionController.text,
        rating: book.rating,
        chapters: book.chapters,
        status: _selectedStatus,
        publishedDate:
            _isPublished ? (book.publishedDate ?? DateTime.now()) : null,
        categories: _selectedGenres.isNotEmpty
            ? _selectedGenres
                .map((name) =>
                    dataService.categories.firstWhere((c) => c.name == name))
                .toList()
            : book.categories,
      );

      dataService.updateBook(updatedBook);
    }

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book updated successfully')),
    );
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final book = dataService.getBookById(widget.bookId);
        final chapters = dataService.getChaptersByBookId(widget.bookId);

        if (book == null) {
          return const Scaffold(
            body: Center(
              child: Text('Book not found'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Edit Book'),
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
                      onPressed: _saveBook,
                      child: const Text('Save'),
                    ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book details section
                Padding(
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
                                width: 100,
                                height: 140,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                  image: (_coverImage != null)
                                      ? DecorationImage(
                                          image: FileImage(_coverImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : (_coverImagePath != null &&
                                              _coverImagePath!
                                                  .startsWith('assets/'))
                                          ? DecorationImage(
                                              image:
                                                  AssetImage(_coverImagePath!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                ),
                                child: (_coverImage == null &&
                                        (_coverImagePath == null ||
                                            !_coverImagePath!
                                                .startsWith('assets/')))
                                    ? const Center(
                                        child: Icon(Icons.image,
                                            size: 40, color: Colors.grey),
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
                      _buildFormField('Title:', _titleController, 'Book title'),
                      const SizedBox(height: 16),
                      _buildMultiSelectGenreField(
                        'Genres:',
                        _selectedGenres,
                        dataService.categories.map((c) => c.name).toList(),
                      ),
                      const SizedBox(height: 16),
                      _buildStatusField(
                        'Status:',
                        _selectedStatus,
                        ['Ongoing', 'Completed'],
                        (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPublishedSwitch(),
                      const SizedBox(height: 16),
                      _buildTextAreaField('Description:',
                          _descriptionController, 'Book description'),
                    ],
                  ),
                ),

                // Divider
                const Divider(height: 32),

                // Chapters section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chapters',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewChapterPage(bookId: widget.bookId),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Chapter'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (chapters.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No chapters yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add your first chapter to start writing',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[500],
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: chapters.length,
                          onReorder: (oldIndex, newIndex) {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final List<Chapter> newOrder = List.from(chapters);
                            final item = newOrder.removeAt(oldIndex);
                            newOrder.insert(newIndex, item);
                            dataService.reorderChapters(
                                widget.bookId, newOrder);
                          },
                          itemBuilder: (context, index) {
                            final chapter = chapters[index];
                            return Card(
                              key: ValueKey(chapter.id),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Text(
                                  '${chapter.order}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                title: Text(chapter.title),
                                subtitle: Text(
                                  '${chapter.content.length} characters',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditChapterPage(
                                                    chapterId: chapter.id),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Chapter'),
                                            content: const Text(
                                                'Are you sure you want to delete this chapter?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  dataService.deleteChapter(
                                                      chapter.id);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditChapterPage(
                                          chapterId: chapter.id),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildMultiSelectGenreField(
    String label,
    List<String> selectedValues,
    List<String> options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedValues
                    .map((genre) => Chip(
                          label: Text(genre),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _toggleGenre(genre),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options
                  .where((genre) => !selectedValues.contains(genre))
                  .map((genre) => ActionChip(
                        label: Text(genre),
                        onPressed: () => _toggleGenre(genre),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusField(
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

  Widget _buildPublishedSwitch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            'Published:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: SwitchListTile(
            title: Text(_isPublished ? 'Published' : 'Not Published'),
            subtitle: Text(_isPublished
                ? 'Your book is visible to readers'
                : 'Your book is only visible to you'),
            value: _isPublished,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setState(() {
                _isPublished = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField(
      String label, TextEditingController controller, String placeholder) {
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
