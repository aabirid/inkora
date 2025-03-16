import 'package:flutter/material.dart';

class ChapterListItem extends StatelessWidget {
  final String title;
  final String lastEdited;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ChapterListItem({
    super.key,
    required this.title,
    required this.lastEdited,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  'Last edited: $lastEdited',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    color: Colors.black54,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined)),
                const SizedBox(width: 8),
                IconButton(
                    color: Colors.red.shade400,
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
