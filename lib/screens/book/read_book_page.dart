import 'package:flutter/material.dart';
import 'package:inkora/widgets/reading_settings_sidebar.dart';
import 'package:inkora/widgets/chapters_sidebar.dart';

class ReadBookPage extends StatefulWidget {
  const ReadBookPage({super.key});

  @override
  State<ReadBookPage> createState() => _ReadBookPageState();
}

class _ReadBookPageState extends State<ReadBookPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _fontSize = 16.0;
  bool _isDarkMode = false;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  int _currentChapterIndex = 8;

  final List<String> _chapters = [
    'Prologue',
    'Chapter 1',
    'Chapter 2',
    'Chapter 3',
    'Chapter 4',
    'Chapter 5',
    'Chapter 6',
    'Chapter 7',
    'Chapter 8',
    'Chapter 9',
    'Chapter 10',
    'Chapter 11',
    'Chapter 12',
    'Chapter 13',
    'Chapter 14',
    'Chapter 15',
    'Chapter 16',
    'Chapter 17',
    'Chapter 18',
  ];

  final String _chapterContent = '"Do you really think we\'ll find Wendy again?" Nibs asked, flying through the night sky.\n\n'
      '"I\'m sure of it," Peter said as they approached the Tower Bridge. "I know where her house is by heart."\n\n'
      'They wove between the two bridge towers, passing over motor cars and horse carriages down below.\n\n'
      '"London sure is big," one twin said, soaring above the Tower of London.\n\n'
      '"Yeah, maybe even bigger than Neverland," the other twin said as they flew by St. Paul\'s Cathedral.\n\n'
      'They closed in on the neighborhood of Bloomsbury.\n\n'
      'Peter and Tink flew down to a corner house. "This is the one! This is where the Darlings live!"\n\n'
      'The Lost Boys caught up with them, and they peered into the windows of the house. "Where\'s Wendy?" Cubby asked.\n\n'
      '"I don\'t know. That\'s what I\'m trying to find out," Peter said. He looked into the nursery window, and he saw John and Michael inside. John was in his bed reading one of his books, and Michael was playing with some toy soldiers on the floor. No Wendy, though.\n\n'
      'Peter floated over to the next window, which was someone\'s bedroom. A girl\'s bedroom, it seemed like. There was a vanity, and at the vanity was a teenaged girl brushing her hair. The girl looked like Wendy. Then it hit Peter that that was Wendy.\n\n'
      '"Wendy?" Peter uttered under his breath.\n\n'
      '"You found her?" Slightly said. The Lost Boys gathered at the window.\n\n'
      '"Yeah, but... she grew up," Peter said.\n\n'
      'The boys gasped.\n\n'
      'Peter continued, "I can\'t believe it. How\'d that happen? It wasn\'t even that long ago since she left."\n\n'
      '"I guess that\'s how things go in the real world," Nibs said.\n\n'
      '"Why do people have to grow up so fast?" Peter said. "It\'s just not fair."\n\n'
      '"Do you still wanna say hi to her?" Cubby said.';

  void _openChaptersSidebar() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _openSettingsSidebar() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _updateFontSize(double size) {
    setState(() {
      _fontSize = size;
    });
  }

  void _updateTheme(Color backgroundColor, Color textColor) {
    setState(() {
      _backgroundColor = backgroundColor;
      _textColor = textColor;
      _isDarkMode = backgroundColor == Colors.black;
    });
  }

  void _selectChapter(int index) {
    setState(() {
      _currentChapterIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final systemBrightness = theme.brightness;
    
    // If we're not explicitly overriding with custom colors, use the system theme
    final effectiveBackgroundColor = _backgroundColor == Colors.white && _textColor == Colors.black
        ? (systemBrightness == Brightness.dark ? Colors.black : Colors.white)
        : _backgroundColor;
    
    final effectiveTextColor = _backgroundColor == Colors.white && _textColor == Colors.black
        ? (systemBrightness == Brightness.dark ? Colors.white : Colors.black)
        : _textColor;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Alice in Neverland'),
        actions: [
          IconButton(
            icon: const Text(
              'Aa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: _openSettingsSidebar,
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _openChaptersSidebar,
          ),
        ],
      ),
      drawer: ChaptersSidebar(
        chapters: _chapters,
        currentChapterIndex: _currentChapterIndex,
        onChapterSelected: _selectChapter,
      ),
      endDrawer: ReadingSettingsSidebar(
        onFontSizeChanged: _updateFontSize,
        onThemeChanged: _updateTheme,
        currentFontSize: _fontSize,
        isDarkMode: _isDarkMode,
      ),
      body: Container(
        color: effectiveBackgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _chapters[_currentChapterIndex],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: effectiveTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _chapterContent,
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: effectiveTextColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

