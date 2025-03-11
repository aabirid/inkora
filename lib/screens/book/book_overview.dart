import 'package:flutter/material.dart';
import 'package:inkora/models/book.dart';
import 'package:inkora/models/comment.dart';

class BookOverview extends StatefulWidget {
  final Book book;

  const BookOverview({Key? key, required this.book}) : super(key: key);

  @override
  _BookOverviewState createState() => _BookOverviewState();
}

class _BookOverviewState extends State<BookOverview> {
  final List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        comments.insert(
          0,
          Comment(
            user: "User123", // Replace with actual user later
            text: _commentController.text.trim(),
            timestamp: DateTime.now(),
          ),
        );
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Colors.green.shade300,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookDetails(),
                  const SizedBox(height: 20),
                  Text(
                    widget.book.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildBookDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            widget.book.coverImage,
            width: 120,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.book.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("by ${widget.book.author}",
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  const SizedBox(width: 4),
                  Text("${widget.book.rating}"),
                  const SizedBox(width: 10),
                  Icon(Icons.menu_book_rounded, color: Colors.grey, size: 20),
                  const SizedBox(width: 5),
                  Text("${widget.book.chapters} chapters"),
                ],
              ),
              const SizedBox(height: 10),
              _buildStatusTag(widget.book.status),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag(String status) {
    Color tagColor = status == "Completed" ? Colors.green : Colors.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Comments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 250, // Fix height to prevent infinite expansion
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(comments[index].user),
                subtitle: Text(comments[index].text),
                trailing: Text(
                  "${comments[index].timestamp.hour}:${comments[index].timestamp.minute}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: "Add a comment...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }
}
