import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';

class SimpleBookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const SimpleBookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              book.coverImage,
              width: 95,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
         // const SizedBox(height: 8),
          Text(
            book.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
