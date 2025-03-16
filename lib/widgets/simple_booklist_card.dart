import 'package:flutter/material.dart';
import 'package:inkora/models/booklist.dart';

class SimpleBooklistCard extends StatelessWidget {
  final Booklist booklist;
  final VoidCallback onTap;

  const SimpleBooklistCard({super.key, required this.booklist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              booklist.coverImage,
              width: 95,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
         // const SizedBox(height: 8),
          Text(
            booklist.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
