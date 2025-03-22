import 'package:flutter/material.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/screens/profile/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:inkora/providers/follow_provider.dart';

class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final followProvider = Provider.of<FollowProvider>(context);
    bool isFollowing = followProvider.isFollowing(user.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(user: user),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 27,
          backgroundImage: user.photo != null
              ? AssetImage(user.photo!)
              : const AssetImage('assets/images/profile_default.jpeg'),
        ),
        title: Text("${user.firstName} ${user.lastName}"),
        subtitle: Text("@${user.username}"),
        trailing: ElevatedButton(
          onPressed: () {
            followProvider.toggleFollow(user.id);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing ? Colors.grey : Colors.green.shade400,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(isFollowing ? "Unfollow" : "Follow"),
        ),
      ),
    );
  }
}
