import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          const SizedBox(height: 12),
          _buildSectionTitle("Saved Books"),
          _buildBookGrid(),
          const SizedBox(height: 20),
          _buildSectionTitle("Saved Booklists"),
          _buildBookGrid(),
        ],
      ),
    );
  }

  // Widget pour afficher le titre de chaque section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  // Widget pour afficher la grille des livres
  Widget _buildBookGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 colonnes comme sur ton design
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6, 
      itemBuilder: (context, index) {
        return _buildBookItem();
      },
    );
  }

  // Widget pour afficher un livre
  Widget _buildBookItem() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            "assets/images/book_cover3.jpeg", 
            width: 100,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          "Fantasy Besties",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
