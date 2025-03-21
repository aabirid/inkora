import 'package:flutter/material.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/screens/search/search_page.dart';
import 'package:inkora/widgets/book_card.dart';

class BooklistOverview extends StatefulWidget {
  final Booklist booklist;

  const BooklistOverview({super.key, required this.booklist});

  @override
  _BooklistOverviewState createState() => _BooklistOverviewState();
}

class _BooklistOverviewState extends State<BooklistOverview> {
  bool isSaved = false; // Local state for bookmark status

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.booklist.title, style: theme.textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              // Handle sharing functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              height: 100, // Fixed height for consistency
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor, // 🎨 Using theme color
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.booklist.title,
                          style: theme.textTheme.titleLarge, // 🎨 Use theme text style
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? theme.primaryColor : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isSaved = !isSaved;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.booklist.likesCount}",
                        style: theme.textTheme.bodyMedium, // 🎨 Themed text
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.menu_book, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.booklist.booksCount}",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: widget.booklist.books != null && widget.booklist.books!.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.booklist.books!.length,
                      itemBuilder: (context, index) {
                        return BookCard(book: widget.booklist.books![index]);
                      },
                    )
                  : Center(
                      child: Text(
                        "No books available in this booklist.",
                        style: theme.textTheme.bodyLarge, // 🎨 Themed text
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
