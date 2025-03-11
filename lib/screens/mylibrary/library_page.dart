import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample books to display
    final books = [
      {'title': 'Book 1', 'author': 'Author A'},
      {'title': 'Book 2', 'author': 'Author B'},
      {'title': 'Book 3', 'author': 'Author C'},
      {'title': 'Book 4', 'author': 'Author D'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text(book['title']!),
              subtitle: Text(book['author']!),
              leading: Icon(Icons.book), // Optional icon for each book
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Handle book deletion (optional)
                  print('Delete ${book['title']}');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
