import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  10.0), // Apply border radius to the image
              child: Image.asset(
                book["coverImage"] ?? 'assets/default_cover.png',
                width: 75,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50);
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book["title"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      _buildStatusTag(book["status"]),
                      SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 3),
                      Text("${book["rating"]}", style: TextStyle(fontSize: 12)),
                      SizedBox(width: 10),
                      Icon(Icons.menu_book_rounded,
                          color: Colors.grey, size: 16),
                      SizedBox(width: 5),
                      Text("${book["chapters"]}",
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    book["description"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
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
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
