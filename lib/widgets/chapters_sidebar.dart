import 'package:flutter/material.dart';

class ChaptersSidebar extends StatelessWidget {
  final List<String> chapters;
  final int currentChapterIndex;
  final Function(int) onChapterSelected;

  const ChaptersSidebar({
    super.key,
    required this.chapters,
    required this.currentChapterIndex,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 250,
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: 25),
          Container(            
            padding: const EdgeInsets.all(25),
            color: theme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [                
                Text(
                  'Chapters',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.primaryColor,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final isSelected = index == currentChapterIndex;
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        chapters[index],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? theme.primaryColor : null,
                        ),
                      ),
                      onTap: () => onChapterSelected(index),
                      selected: isSelected,
                      selectedTileColor: theme.primaryColor.withOpacity(0.1),
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

