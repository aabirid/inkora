import 'package:flutter/material.dart';
import 'package:inkora/widgets/chapter_list_item.dart';
import 'edit_chapter_page.dart';  // Ensure this import is here

class EditBookPage extends StatefulWidget {
  const EditBookPage({super.key});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  List<Map<String, String>> chapters = [
    {'title': 'Prologue', 'lastEdited': '23/11/2023'},
    {'title': 'Chapter 1', 'lastEdited': '23/11/2023'},
    {'title': 'Chapter 2', 'lastEdited': '23/11/2023'},
    {'title': 'Chapter 3', 'lastEdited': '23/11/2023'},
    {'title': 'Chapter 4', 'lastEdited': '23/11/2023'},
    {'title': 'Chapter 5', 'lastEdited': '23/11/2023'},
    {'title': 'Chapter 6', 'lastEdited': '23/11/2023'},
    {'title': 'Chapter 7', 'lastEdited': '23/11/2023'},
    {'title': 'Chapter 8', 'lastEdited': '23/11/2023'},
  ];

  String bookStatus = 'In Progress';

  void _editChapter(int index) {
    // Navigate to the EditChapterPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChapterPage(chapter: chapters[index]),
      ),
    );
  }

  void _deleteChapter(int index) {
    setState(() {
      chapters.removeAt(index);
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
        title: const Text('Edit Book: Alice in Neverland'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Book Status',
                    style: theme.textTheme.bodyLarge,
                  ),
                  // Improved Dropdown Button using DropdownButton
                  DropdownButton<String>(
                    value: bookStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        bookStatus = newValue!;
                      });
                    },
                    items: <String>['In Progress', 'Completed']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    underline: Container(),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...chapters.map((chapter) {
                final index = chapters.indexOf(chapter);
                return ChapterListItem(
                  title: chapter['title']!,
                  lastEdited: chapter['lastEdited']!,
                  onEdit: () => _editChapter(index),
                  onDelete: () => _deleteChapter(index),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
