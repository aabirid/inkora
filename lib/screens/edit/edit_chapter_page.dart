import 'package:flutter/material.dart';

class EditChapterPage extends StatefulWidget {
  final Map<String, String> chapter;

  const EditChapterPage({super.key, required this.chapter});

  @override
  _EditChapterPageState createState() => _EditChapterPageState();
}

class _EditChapterPageState extends State<EditChapterPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.chapter['title']);
    _contentController = TextEditingController(text: widget.chapter['content']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
        title: const Text('Edit Chapter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Chapter: ${widget.chapter['title']}',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Chapter Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Content Field
              TextFormField(
                controller: _contentController,
                maxLines: 10, // Allows for multiple lines of content
                decoration: const InputDecoration(
                  labelText: 'Chapter Content',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Handle saving the chapter with updated title and content
                  Map<String, String> updatedChapter = {
                    'title': _titleController.text,
                    'content': _contentController.text,
                  };
                  // You can send the updatedChapter to a database or wherever necessary
                  Navigator.pop(context, updatedChapter);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
