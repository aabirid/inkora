import 'package:flutter/material.dart';

class AuthorCard extends StatelessWidget {
  final Map<String, dynamic> author;

  const AuthorCard({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            radius: 27,
            backgroundImage: AssetImage(author["profile-picture"]),
          ),
          title: Text(author["name"]),
          trailing: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1), // Padding
              elevation: 1, 
            ),
            child: Text(
              "Follow",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}
