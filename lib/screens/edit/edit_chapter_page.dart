import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inkora/models/chapter.dart';
import 'package:inkora/services/mock_data_service.dart';

class EditChapterPage extends StatefulWidget {
  final int chapterId;

  const EditChapterPage({super.key, required this.chapterId});

  @override
  State<EditChapterPage> createState() => _EditChapterPageState();
}

class _EditChapterPageState extends State<EditChapterPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Schedule getting the data service after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final dataService = Provider.of<MockDataService>(context, listen: false);
        
        // Load chapter data
        final chapter = dataService.chapters.firstWhere(
          (c) => c.id == widget.chapterId,
          orElse: () => Chapter(id: 0, bookId: 0, title: '', order: 0, content: ''),
        );
        
        if (chapter.id != 0 && mounted) {
          setState(() {
            _titleController.text = chapter.title;
            _contentController.text = chapter.content;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveChapter() {
    setState(() {
      _isLoading = true;
    });

    final dataService = Provider.of<MockDataService>(context, listen: false);
    
    try {
      final chapter = dataService.chapters.firstWhere(
        (c) => c.id == widget.chapterId,
        orElse: () => Chapter(id: 0, bookId: 0, title: '', order: 0, content: ''),
      );
      
      if (chapter.id != 0) {
        dataService.updateChapter(Chapter(
          id: chapter.id,
          bookId: chapter.bookId,
          title: _titleController.text,
          order: chapter.order,
          content: _contentController.text,
        ));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chapter saved')),
        );
      }
    } catch (e) {
      print('Error saving chapter: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving chapter: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
    
    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final chapter = dataService.chapters.firstWhere(
          (c) => c.id == widget.chapterId,
          orElse: () => Chapter(id: 0, bookId: 0, title: '', order: 0, content: ''),
        );
        
        if (chapter.id == 0) {
          return const Scaffold(
            body: Center(
              child: Text('Chapter not found'),
            ),
          );
        }
        
        final book = dataService.getBookById(chapter.bookId);
        
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(book?.title ?? 'Edit Chapter'),
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
              // Status bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Text(
                      'Chapter ${chapter.order}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
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

