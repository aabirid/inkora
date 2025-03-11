import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';

class BookOverview extends StatelessWidget {
  final Book book;

  const BookOverview({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.deepPurple, // Adjust based on your theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    book.coverImage,
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "by ${book.author}",
                        style: const TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          const SizedBox(width: 4),
                          Text("${book.rating}"),
                          const SizedBox(width: 10),
                          Icon(Icons.menu_book_rounded,
                              color: Colors.grey, size: 20),
                          const SizedBox(width: 5),
                          Text("${book.chapters} chapters"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildStatusTag(book.status),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              book.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Open book reader or download
                },
                icon: Icon(Icons.book),
                label: Text("Read Now"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color tagColor = status == "Completed" ? Colors.green : Colors.blue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
