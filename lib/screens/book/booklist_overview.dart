import 'package:flutter/material.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/screens/search/search_page.dart';
import 'package:inkora/widgets/booklist_card.dart';
import 'package:inkora/widgets/book_card.dart';

class BooklistOverview extends StatelessWidget {
  final Booklist booklist;

  const BooklistOverview({super.key, required this.booklist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(booklist.title),
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
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BooklistCard(booklist: booklist),
            const SizedBox(height: 10),
            Expanded(
              child: booklist.books != null && booklist.books!.isNotEmpty
                  ? ListView.builder(
                      itemCount: booklist.books!.length,
                      itemBuilder: (context, index) {
                        return BookCard(book: booklist.books![index]);
                      },
                    )
                  : const Center(
                      child: Text(
                        "No books available in this booklist.",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
