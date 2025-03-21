import 'package:flutter/material.dart';

class NewChapterPage extends StatefulWidget {
  final String?
      bookId; // Optional parameter to specify which book this chapter belongs to

  const NewChapterPage({super.key, this.bookId});

  @override
  State<NewChapterPage> createState() => _NewChapterPageState();
}

class _NewChapterPageState extends State<NewChapterPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

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

    // Simulate saving - replace with actual save logic
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      // Navigate back after saving
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Chapter'),
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
                  onPressed:
                      _titleController.text.isNotEmpty ? _saveChapter : null,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: _titleController.text.isNotEmpty
                          ? theme.primaryColor
                          : theme.primaryColor.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
              // Chapter Title
              TextField(
                controller: _titleController,
                onChanged: (value) => setState(() {}),
                style: theme.textTheme.titleLarge,
                decoration: InputDecoration(
                  hintText: 'Chapter Title',
                  hintStyle:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.grey),
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
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                decoration: InputDecoration(
                  hintText: 'Start writing your chapter here...',
                  hintStyle:
                      theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
