import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/chapter.dart';
import 'package:inkora/models/category.dart';
import 'package:inkora/models/booklist.dart';

class MockDataService extends ChangeNotifier {
  // Singleton pattern
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal() {
    // Initialize with mock data
    _initializeMockData();
  }

  // Mock data
  List<Book> _books = [];
  List<Chapter> _chapters = [];
  List<Category> _categories = [];
  List<Booklist> _booklists = [];

  // Initialize mock data
  void _initializeMockData() {
    _categories = [
      Category(id: 1, name: 'Fantasy'),
      Category(id: 2, name: 'Adventure'),
      Category(id: 3, name: 'Thriller'),
      Category(id: 4, name: 'Mystery'),
      Category(id: 5, name: 'Romance'),
      Category(id: 6, name: 'Science Fiction'),
      Category(id: 7, name: 'Horror'),
      Category(id: 8, name: 'Historical Fiction'),
      Category(id: 9, name: 'Biography'),
      Category(id: 10, name: 'Self-Help'),
    ];

    _books = [
      Book(
        id: 1,
        title: 'The Lost Kingdom',
        author: 'John Doe',
        coverImage: 'assets/images/book_cover7.jpeg',
        description: 'A fantasy novel about a hidden kingdom and its secrets.',
        rating: 4.5,
        chapters: 12,
        status: 'Ongoing',
        publishedDate: DateTime(2023, 5, 15),
        categories: [
          _categories.firstWhere((c) => c.id == 1),
          _categories.firstWhere((c) => c.id == 2),
        ],
      ),
      Book(
        id: 2,
        title: 'Midnight Shadows',
        author: 'Jane Smith',
        coverImage: 'assets/images/book_cover5.jpeg',
        description: 'A thriller set in a small town with a dark past.',
        rating: 4.2,
        chapters: 8,
        status: 'Ongoing',
        publishedDate: DateTime(2023, 7, 22),
        categories: [
          _categories.firstWhere((c) => c.id == 3),
          _categories.firstWhere((c) => c.id == 4),
        ],
      ),
    ];

    _chapters = [
      Chapter(
        id: 1,
        bookId: 1,
        title: 'The Beginning',
        order: 1,
        content: 'Once upon a time in a land far away...',
      ),
      Chapter(
        id: 2,
        bookId: 1,
        title: 'The Journey',
        order: 2,
        content: 'The heroes set out on their epic journey...',
      ),
      Chapter(
        id: 3,
        bookId: 2,
        title: 'Arrival',
        order: 1,
        content: 'The detective arrived in the small town as dusk was falling...',
      ),
    ];
    
    _booklists = [
      Booklist(
        id: 1,
        userId: 1,
        title: 'My Favorite Fantasy Books',
        visibility: 'Public',
        creationDate: DateTime(2023, 1, 15),
        books: [_books[0]],
        likesCount: 24,
        booksCount: 1,        
      ),
      Booklist(
        id: 2,
        userId: 1,
        title: 'Mystery Collection',
        visibility: 'Private',
        creationDate: DateTime(2023, 3, 10),
        books: [_books[1]],
        likesCount: 5,
        booksCount: 1,        
      ),
    ];
  }

  // Getters
  List<Book> get books => List.unmodifiable(_books);
  List<Chapter> get chapters => List.unmodifiable(_chapters);
  List<Category> get categories => List.unmodifiable(_categories);
  List<Booklist> get booklists => List.unmodifiable(_booklists);

  // Methods
  List<Chapter> getChaptersByBookId(int bookId) {
    final bookChapters = _chapters.where((chapter) => chapter.bookId == bookId).toList();
    bookChapters.sort((a, b) => a.order.compareTo(b.order));
    return bookChapters;
  }

  Book? getBookById(int id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Booklist? getBooklistById(int id) {
    try {
      return _booklists.firstWhere((booklist) => booklist.id == id);
    } catch (e) {
      return null;
    }
  }

  // CRUD operations - Modified to use Future.microtask
  void addBook(Book book) {
    // Schedule the state change for after the current build phase
    Future.microtask(() {
      final newId = _books.isEmpty ? 1 : _books.map((b) => b.id).reduce((a, b) => a > b ? a : b) + 1;
      final newBook = Book(
        id: newId,
        title: book.title,
        author: book.author,
        coverImage: book.coverImage,
        description: book.description,
        rating: 0.0,
        chapters: 0,
        status: 'Draft',
        publishedDate: null,
        categories: book.categories,
      );
      
      _books.add(newBook);
      notifyListeners();
    });
  }

  void updateBook(Book book) {
    Future.microtask(() {
      final index = _books.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        _books[index] = book;
        notifyListeners();
      }
    });
  }

  void deleteBook(int id) {
    Future.microtask(() {
      _books.removeWhere((book) => book.id == id);
      _chapters.removeWhere((chapter) => chapter.bookId == id);
      
      // Also remove the book from any booklists
      for (int i = 0; i < _booklists.length; i++) {
        final booklist = _booklists[i];
        if (booklist.books != null) {
          final updatedBooks = booklist.books!.where((book) => book.id != id).toList();
          _booklists[i] = Booklist(
            id: booklist.id,
            userId: booklist.userId,
            title: booklist.title,
            visibility: booklist.visibility,
            creationDate: booklist.creationDate,
            books: updatedBooks,
            likesCount: booklist.likesCount,
            booksCount: updatedBooks.length,           
          );
        }
      }
      
      notifyListeners();
    });
  }
  
  void deleteBooklist(int id) {
    Future.microtask(() {
      _booklists.removeWhere((booklist) => booklist.id == id);
      notifyListeners();
    });
  }
  
  void updateBooklist(Booklist booklist) {
    Future.microtask(() {
      final index = _booklists.indexWhere((b) => b.id == booklist.id);
      if (index != -1) {
        _booklists[index] = booklist;
        notifyListeners();
      }
    });
  }

  void addChapter(Chapter chapter) {
    Future.microtask(() {
      final newId = _chapters.isEmpty ? 1 : _chapters.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
      final bookChapters = getChaptersByBookId(chapter.bookId);
      final newOrder = bookChapters.isEmpty ? 1 : bookChapters.map((c) => c.order).reduce((a, b) => a > b ? a : b) + 1;
      
      final newChapter = Chapter(
        id: newId,
        bookId: chapter.bookId,
        title: chapter.title,
        order: chapter.order == 0 ? newOrder : chapter.order,
        content: chapter.content,
      );
      
      _chapters.add(newChapter);
      
      // Update book chapters count
      final bookIndex = _books.indexWhere((b) => b.id == chapter.bookId);
      if (bookIndex != -1) {
        final updatedBook = _books[bookIndex];
        _books[bookIndex] = Book(
          id: updatedBook.id,
          title: updatedBook.title,
          author: updatedBook.author,
          coverImage: updatedBook.coverImage,
          description: updatedBook.description,
          rating: updatedBook.rating,
          chapters: getChaptersByBookId(updatedBook.id).length,
          status: updatedBook.status,
          publishedDate: updatedBook.publishedDate,
          categories: updatedBook.categories,
        );
      }
      
      notifyListeners();
    });
  }

  void updateChapter(Chapter chapter) {
    Future.microtask(() {
      final index = _chapters.indexWhere((c) => c.id == chapter.id);
      if (index != -1) {
        _chapters[index] = chapter;
        notifyListeners();
      }
    });
  }

  void deleteChapter(int id) {
    Future.microtask(() {
      final chapter = _chapters.firstWhere((c) => c.id == id, orElse: () => Chapter(id: 0, bookId: 0, title: '', order: 0, content: ''));
      if (chapter.id != 0) {
        final bookId = chapter.bookId;
        _chapters.removeWhere((c) => c.id == id);
        
        // Update book chapters count
        final bookIndex = _books.indexWhere((b) => b.id == bookId);
        if (bookIndex != -1) {
          final updatedBook = _books[bookIndex];
          _books[bookIndex] = Book(
            id: updatedBook.id,
            title: updatedBook.title,
            author: updatedBook.author,
            coverImage: updatedBook.coverImage,
            description: updatedBook.description,
            rating: updatedBook.rating,
            chapters: getChaptersByBookId(updatedBook.id).length,
            status: updatedBook.status,
            publishedDate: updatedBook.publishedDate,
            categories: updatedBook.categories,
          );
        }
        
        notifyListeners();
      }
    });
  }

  void reorderChapters(int bookId, List<Chapter> newOrder) {
    Future.microtask(() {
      for (int i = 0; i < newOrder.length; i++) {
        final chapter = newOrder[i];
        final index = _chapters.indexWhere((c) => c.id == chapter.id);
        if (index != -1) {
          _chapters[index] = Chapter(
            id: chapter.id,
            bookId: chapter.bookId,
            title: chapter.title,
            order: i + 1,
            content: chapter.content,
          );
        }
      }
      notifyListeners();
    });
  }
}

