import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/chapter.dart';
import 'package:inkora/services/mock_data_service.dart';

class NewChapterPage extends StatefulWidget {
  final int? bookId; // Optional parameter to specify which book this chapter belongs to

  const NewChapterPage({super.key, this.bookId});

  @override
  State<NewChapterPage> createState() => _NewChapterPageState();
}

class _NewChapterPageState extends State<NewChapterPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  int? _selectedBookId;

  @override
  void initState() {
    super.initState();
    _selectedBookId = widget.bookId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveChapter() {
    if (_selectedBookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a book')),
      );
      return;
    }
    
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final dataService = Provider.of<MockDataService>(context, listen: false);

    // Create new chapter
    final newChapter = Chapter(
      id: 0, // Will be assigned by the service
      bookId: _selectedBookId!,
      title: _titleController.text,
      order: 0, // Will be assigned by the service
      content: _contentController.text,
    );
  
    dataService.addChapter(newChapter);
  
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chapter saved')),
    );
    
    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final books = dataService.books;
        Book? selectedBook;
        
        if (_selectedBookId != null) {
          selectedBook = dataService.getBookById(_selectedBookId!);
        }
        
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(selectedBook?.title ?? 'New Chapter'),
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
                      onPressed: _saveChapter,
                      child: const Text('Save'),
                    ),
            ],
          ),
          body: Column(
            children: [
              // Book selector (if not provided)
              if (_selectedBookId == null)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      const Text(
                        'Select Book:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButton<int>(
                            value: _selectedBookId,
                            hint: const Text('Select a book'),
                            isExpanded: true,
                            underline: Container(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedBookId = newValue;
                                });
                              }
                            },
                            items: books.map<DropdownMenuItem<int>>((Book book) {
                              return DropdownMenuItem<int>(
                                value: book.id,
                                child: Text(book.title),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Editor
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chapter Title
                        TextField(
                          controller: _titleController,
                          style: Theme.of(context).textTheme.titleLarge,
                          decoration: InputDecoration(
                            hintText: 'Chapter Title',
                            hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 16),
                
                        // Chapter Content
                        TextField(
                          controller: _contentController,
                          maxLines: null,
                          minLines: 15,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                          decoration: InputDecoration(
                            hintText: 'Start writing your chapter here...',
                            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Word count bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Text(
                      '${_wordCount(_contentController.text)} words',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_contentController.text.length} characters',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _wordCount(String text) {
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }
}

