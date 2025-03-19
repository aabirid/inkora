import 'package:flutter/material.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/screens/profile/profile_page.dart';

class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(user: user), // Pass the selected user
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 27,
          backgroundImage: user.photo != null
              ? AssetImage(user.photo!)
              : AssetImage('assets/images/profile_default.jpeg'),
        ),
        title: Text("${user.firstName} ${user.lastName}"),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade400,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text("Follow"),
        ),
      ),
    );
  }
}
