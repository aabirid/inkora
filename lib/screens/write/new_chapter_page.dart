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
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
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
              // Chapter Number/Position
              Row(
                children: [
                  Text(
                    'Chapter Position:',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Text('End of Book'),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down,
                            size: 18, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

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
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.all(16.0),
      //   decoration: BoxDecoration(
      //     color: theme.scaffoldBackgroundColor,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.05),
      //         blurRadius: 5,
      //         offset: const Offset(0, -1),
      //       ),
      //     ],
      //   ),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     _buildToolbarButton(
      //       icon: Icons.format_bold,
      //       tooltip: 'Bold',
      //       onPressed: () {},
      //     ),
      //     _buildToolbarButton(
      //       icon: Icons.format_italic,
      //       tooltip: 'Italic',
      //       onPressed: () {},
      //     ),
      //     _buildToolbarButton(
      //       icon: Icons.format_underlined,
      //       tooltip: 'Underline',
      //       onPressed: () {},
      //     ),
      //     _buildToolbarButton(
      //       icon: Icons.format_list_bulleted,
      //       tooltip: 'Bullet List',
      //       onPressed: () {},
      //     ),
      //     _buildToolbarButton(
      //       icon: Icons.format_list_numbered,
      //       tooltip: 'Numbered List',
      //       onPressed: () {},
      //     ),
      //     _buildToolbarButton(
      //       icon: Icons.format_quote,
      //       tooltip: 'Quote',
      //       onPressed: () {},
      //     ),
      //   ],
      // ),),
    );
  }

  // Widget _buildToolbarButton({
  //   required IconData icon,
  //   required String tooltip,
  //   required VoidCallback onPressed,
  // }) {
  //   return IconButton(
  //     icon: Icon(icon),
  //     tooltip: tooltip,
  //     onPressed: onPressed,
  //   );
  // }
}
