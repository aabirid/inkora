import 'package:flutter/material.dart';
import 'package:inkora/widgets/reading_settings_sidebar.dart';
import 'package:inkora/widgets/chapters_sidebar.dart';
import 'package:inkora/services/api_service.dart';
import 'package:inkora/models/chapter.dart';
import 'package:inkora/models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadBookPage extends StatefulWidget {
  final int bookId;
  
  const ReadBookPage({super.key, required this.bookId});

  @override
  State<ReadBookPage> createState() => _ReadBookPageState();
}

class _ReadBookPageState extends State<ReadBookPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  
  Book? _book;
  List<Chapter> _chapters = [];
  int _currentChapterIndex = 0;
  int _userId = 1; // Default user ID, should be replaced with actual logged-in user ID
  
  double _fontSize = 16.0;
  bool _isDarkMode = false;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  
  String _chapterContent = 'Loading chapter content...';

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) => _loadData());
  }

  Future<void> _loadUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userId = prefs.getInt('user_id') ?? 1;
      });
    } catch (e) {
      print('Error loading user ID: $e');
      // Continue with default user ID
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Load book details
      final book = await _apiService.getBookById(widget.bookId);
      
      // Load chapters
      final chapters = await _apiService.getChaptersByBookId(widget.bookId);
      
      if (chapters.isEmpty) {
        setState(() {
          _book = book;
          _chapters = [];
          _chapterContent = 'This book has no chapters yet.';
          _isLoading = false;
        });
        return;
      }
      
      // Get user's reading progress
      int currentChapterId = 0;
      try {
        currentChapterId = await _apiService.getReadingProgress(_userId, widget.bookId);
      } catch (e) {
        print('Error getting reading progress: $e');
        // Continue with first chapter
      }
      
      // Find the index of the current chapter
      int index = 0;
      if (currentChapterId > 0) {
        index = chapters.indexWhere((chapter) => chapter.id == currentChapterId);
        if (index == -1) index = 0; // Default to first chapter if not found
      }
      
      // Load chapter content
      String content = 'Loading chapter content...';
      try {
        content = await _apiService.getChapterContent(chapters[index].id);
      } catch (e) {
        print('Error loading chapter content: $e');
        content = 'Failed to load chapter content. Please try again.';
      }
      
      if (mounted) {
        setState(() {
          _book = book;
          _chapters = chapters;
          _currentChapterIndex = index;
          _chapterContent = content;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading book data: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load book: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadChapterContent(int chapterId) async {
    setState(() {
      _chapterContent = 'Loading chapter content...';
    });
    
    try {
      final content = await _apiService.getChapterContent(chapterId);
      
      // Update reading progress
      try {
        await _apiService.updateReadingProgress(_userId, widget.bookId, chapterId);
      } catch (e) {
        print('Error updating reading progress: $e');
        // Continue without updating progress
      }
      
      if (mounted) {
        setState(() {
          _chapterContent = content;
        });
      }
    } catch (e) {
      print('Error loading chapter content: $e');
      if (mounted) {
        setState(() {
          _chapterContent = 'Failed to load chapter content: ${e.toString()}';
        });
      }
    }
  }

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

  void _selectChapter(int index) async {
    if (index >= 0 && index < _chapters.length && index != _currentChapterIndex) {
      setState(() {
        _currentChapterIndex = index;
      });
      
      await _loadChapterContent(_chapters[index].id);
      Navigator.pop(context); // Close the drawer
    }
  }

  void _goToPreviousChapter() {
    if (_currentChapterIndex > 0) {
      final newIndex = _currentChapterIndex - 1;
      setState(() {
        _currentChapterIndex = newIndex;
      });
      _loadChapterContent(_chapters[newIndex].id);
    }
  }

  void _goToNextChapter() {
    if (_currentChapterIndex < _chapters.length - 1) {
      final newIndex = _currentChapterIndex + 1;
      setState(() {
        _currentChapterIndex = newIndex;
      });
      _loadChapterContent(_chapters[newIndex].id);
    }
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
        title: Text(_book?.title ?? 'Reading'),
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
      drawer: _chapters.isEmpty 
          ? null 
          : ChaptersSidebar(
              chapters: _chapters.map((c) => c.title).toList(),
              currentChapterIndex: _currentChapterIndex,
              onChapterSelected: _selectChapter,
            ),
      endDrawer: ReadingSettingsSidebar(
        onFontSizeChanged: _updateFontSize,
        onThemeChanged: _updateTheme,
        currentFontSize: _fontSize,
        isDarkMode: _isDarkMode,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _hasError 
              ? _buildErrorView()
              : Container(
                  color: effectiveBackgroundColor,
                  child: Stack(
                    children: [
                      // Main content
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _chapters.isNotEmpty && _currentChapterIndex < _chapters.length
                                    ? _chapters[_currentChapterIndex].title
                                    : 'Chapter',
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
                              const SizedBox(height: 60), // Space for navigation buttons
                            ],
                          ),
                        ),
                      ),
                      
                      // Navigation buttons
                      if (_chapters.isNotEmpty)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: effectiveBackgroundColor.withOpacity(0.9),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: _currentChapterIndex > 0
                                        ? effectiveTextColor
                                        : effectiveTextColor.withOpacity(0.3),
                                  ),
                                  onPressed: _currentChapterIndex > 0 ? _goToPreviousChapter : null,
                                  tooltip: 'Previous Chapter',
                                ),
                                Text(
                                  '${_currentChapterIndex + 1} / ${_chapters.length}',
                                  style: TextStyle(color: effectiveTextColor),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: _currentChapterIndex < _chapters.length - 1
                                        ? effectiveTextColor
                                        : effectiveTextColor.withOpacity(0.3),
                                  ),
                                  onPressed: _currentChapterIndex < _chapters.length - 1 ? _goToNextChapter : null,
                                  tooltip: 'Next Chapter',
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

