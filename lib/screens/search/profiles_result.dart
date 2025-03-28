import 'package:flutter/material.dart';
import 'package:inkora/widgets/profile_card.dart';
import 'package:inkora/models/user.dart';

class ProfilesResult extends StatelessWidget {
  final String query;

  ProfilesResult({super.key, required this.query});

  final List<User> profiles = [
    User(
      id: 1,
      email: "max@example.com",
      password: "hidden",
      gender: "Male",
      registrationDate: DateTime.now(),
      status: "active",
      photo: 'assets/images/book_cover3.jpeg',
      username: 'maxjackson',  // New field
      bio: 'Software Developer from California',  // New field
    ),
    User(
      id: 2,
      email: "mia@example.com",
      password: "hidden",
      gender: "Female",
      registrationDate: DateTime.now(),
      status: "active",
      photo: 'assets/images/book_cover2.jpeg',
      username: 'miapotter',  // New field
      bio: 'Lover of books and travel',  // New field
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<User> filteredProfiles = profiles.where((user) {
      return user.username.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return filteredProfiles.isEmpty
        ? Center(child: Text("No Profiles found for '$query'"))
        : ListView.builder(
            itemCount: filteredProfiles.length,
            itemBuilder: (context, index) {
              return ProfileCard(user: filteredProfiles[index]);
            },
          );
  }
}
