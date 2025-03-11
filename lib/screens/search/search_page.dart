import 'package:flutter/material.dart';
import 'package:inkora/screens/search/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> genres = [
    {"name": "Fantasy", "image": "assets/images/fantasy.jpeg"},
    {"name": "Horror", "image": "assets/images/horror.jpeg"},
    {"name": "Romance", "image": "assets/images/romance.jpeg"},
    {"name": "Non-Fiction", "image": "assets/images/nonfiction.jpeg"},
    {"name": "Adventure", "image": "assets/images/adventure.jpeg"},
    {"name": "Mystery", "image": "assets/images/mystery.jpeg"},
    {"name": "Thriller", "image": "assets/images/thriller.jpeg"},
    {"name": "Historical", "image": "assets/images/historical.jpeg"},
    {"name": "Poetry", "image": "assets/images/poetry.jpeg"},
  ];

  void _performSearch() {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchResultsPage(query: query)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                ),
                onSubmitted: (query) => _performSearch(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _performSearch,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: genres.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Search by genre
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchResultsPage(query: genres[index]["name"]!)),
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(genres[index]["image"]!),
                  ),
                  SizedBox(height: 5),
                  Text(genres[index]["name"]!, style: TextStyle(fontSize: 14)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
