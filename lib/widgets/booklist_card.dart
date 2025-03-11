import 'package:flutter/material.dart';
import 'package:inkora/screens/book/booklist_overview.dart';

class BooklistCard extends StatelessWidget {
  final Map<String, dynamic> booklist;

  BooklistCard({required this.booklist});

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BooklistOverview(booklist: booklist),
          ),
        );
      },
      child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12), // Rounded corners for the card itself
      ),
      child: Row(        
        children: [
          // Image with border radius
          ClipRRect(
            borderRadius:
                BorderRadius.circular(10.0), // Apply border radius to the image
            child: Image.asset(
              booklist["coverImage"] ?? 'assets/default_cover.png',
              width: 75,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50);
              },
            ),
          ),
          SizedBox(width: 10), // Add some space between the image and text
          // Text section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booklist["title"] ?? 'Unknown Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.favorite,
                      size: 16, color: Colors.grey), // Like icon
                  SizedBox(width: 4), // Small spacing
                  Text(
                    "${booklist["likes"] ?? 0}",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(width: 12), // Space between like and book icons
                  Icon(Icons.menu_book,
                      size: 16, color: Colors.grey), 
                  SizedBox(width: 4),
                  Text(
                    "${booklist["books"] ?? 0}",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
