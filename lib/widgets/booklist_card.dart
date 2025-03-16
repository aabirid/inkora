import 'package:flutter/material.dart';
import 'package:inkora/screens/book/booklist_overview.dart';
import 'package:inkora/models/booklist.dart'; 

class BooklistCard extends StatelessWidget {
  final Booklist booklist;

  const BooklistCard({super.key, required this.booklist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BooklistOverview(booklist: booklist), // Pass Booklist object
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Rounded corners for the card itself
        ),
        child: Row(
          children: [
            // Image with border radius
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // Apply border radius to the image
              child: Image.asset(
                booklist.coverImage, // Access coverImage from Booklist object
                width: 75,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50); // Error handling
                },
              ),
            ),
            const SizedBox(width: 10), // Add some space between the image and text
            // Text section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booklist.title, // Access title from Booklist object
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 16, color: Colors.grey), // Like icon
                    const SizedBox(width: 4), // Small spacing
                    Text(
                      "${booklist.likes}", // Access likes from Booklist object
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 12), // Space between like and book icons
                    const Icon(Icons.menu_book, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${booklist.booksCount}", // Access booksCount from Booklist object
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
