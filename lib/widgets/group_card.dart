import 'package:flutter/material.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/providers/forum_data_provider.dart';
import 'package:inkora/screens/forum/group_overview.dart';
import 'package:provider/provider.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<ForumDataProvider>(context);
    bool isJoined = groupProvider.isJoined(group.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupOverview(group: group),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 27,
          backgroundImage: group.photo != null
              ? AssetImage(group.photo!)
              : const AssetImage('assets/images/book_cover7.jpeg'),
        ),
        title: Text(group.name),
        subtitle: Text("${group.members?.length ?? 0} members"),
        trailing: ElevatedButton(
          onPressed: () {
            groupProvider.toggleJoinGroup(group.id);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isJoined ? Colors.grey : Colors.green.shade400,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(isJoined ? "Joined" : "Join"),
        ),
      ),
    );
  }
}

