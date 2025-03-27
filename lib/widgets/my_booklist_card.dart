import 'package:flutter/material.dart';
import 'package:inkora/screens/book/booklist_overview.dart';
import 'package:inkora/models/booklist.dart';
import 'package:provider/provider.dart';
import 'package:inkora/services/mock_data_service.dart';
import 'package:inkora/screens/edit/edit_booklist_page.dart';

class MyBooklistCard extends StatelessWidget {
  final Booklist booklist;

  const MyBooklistCard({super.key, required this.booklist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BooklistOverview(booklist: booklist), // Pass Booklist object
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for the card itself
        ),
        child: Row(
          children: [
            // Image with border radius
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  10.0), // Apply border radius to the image
              child: Image.asset(
                booklist.coverImage, // Access coverImage from Booklist object
                width: 75,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 50); // Error handling
                },
              ),
            ),
            const SizedBox(
                width: 10), // Add some space between the image and text
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booklist.title, // Access title from Booklist object
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      _buildVisibilityTag(booklist.visibility),
                      const SizedBox(width: 10),
                      const Icon(Icons.favorite,
                          size: 16, color: Colors.grey), // Like icon
                      const SizedBox(width: 4), // Small spacing
                      Text(
                        "${booklist.likesCount}", // Access likes from Booklist object
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(
                          width: 12), // Space between like and book icons
                      const Icon(Icons.menu_book, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${booklist.booksCount}", // Access booksCount from Booklist object
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildActionButton(
                        context,
                        icon: Icons.edit,
                        label: 'Edit',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBooklistPage(booklist: booklist),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        context,
                        icon: Icons.delete_outlined,
                        label: 'Delete',
                        onTap: () {
                          _showDeleteConfirmation(context, booklist.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int booklistId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Booklist'),
        content: const Text('Are you sure you want to delete this booklist? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add delete functionality here
              final dataService = Provider.of<MockDataService>(context, listen: false);
              // Assuming there's a deleteBooklist method in your service
              // dataService.deleteBooklist(booklistId);
              Navigator.pop(context); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booklist deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityTag(String visibility) {
    Color tagColor = visibility == "Public" ? Colors.green : Colors.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        visibility,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
   Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
