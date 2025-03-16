import 'package:flutter/material.dart';

class ReadingSettingsSidebar extends StatelessWidget {
  final Function(double) onFontSizeChanged;
  final Function(Color, Color) onThemeChanged;
  final double currentFontSize;
  final bool isDarkMode;

  const ReadingSettingsSidebar({
    super.key,
    required this.onFontSizeChanged,
    required this.onThemeChanged,
    this.currentFontSize = 16.0,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSystemDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      width: 250,
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Color',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildThemeOption(
                    context,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    label: 'Aa',
                    isSelected: !isDarkMode && !isSystemDarkMode,
                    onTap: () => onThemeChanged(Colors.white, Colors.black),
                  ),
                  const SizedBox(width: 12),
                  _buildThemeOption(
                    context,
                    backgroundColor: const Color(0xFFF5E6D0),
                    textColor: Colors.black,
                    label: 'Aa',
                    isSelected: false,
                    onTap: () => onThemeChanged(const Color(0xFFF5E6D0), Colors.black),
                  ),
                  const SizedBox(width: 12),
                  _buildThemeOption(
                    context,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    label: 'Aa',
                    isSelected: isDarkMode || isSystemDarkMode,
                    onTap: () => onThemeChanged(Colors.black, Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Font Size',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildFontSizeButton(
                    context,
                    icon: Icons.remove,
                    onTap: () => onFontSizeChanged(currentFontSize - 1),
                  ),
                  Expanded(
                    child: Slider(
                      value: currentFontSize,
                      min: 12.0,
                      max: 24.0,
                      divisions: 12,
                      activeColor: theme.primaryColor,
                      onChanged: onFontSizeChanged,
                    ),
                  ),
                  _buildFontSizeButton(
                    context,
                    icon: Icons.add,
                    onTap: () => onFontSizeChanged(currentFontSize + 1),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Line Spacing',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Slider(
                value: 1.5,
                min: 1.0,
                max: 2.0,
                divisions: 4,
                activeColor: theme.primaryColor,
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              Text(
                'Margins',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Slider(
                value: 16.0,
                min: 8.0,
                max: 32.0,
                divisions: 6,
                activeColor: theme.primaryColor,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required Color backgroundColor,
    required Color textColor,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

