import 'package:flutter/material.dart';
import 'package:inkora/widgets/profile_card.dart';
import 'package:provider/provider.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/providers/forum_data_provider.dart';

class GroupOverview extends StatefulWidget {
  final Group group;

  const GroupOverview({super.key, required this.group});

  @override
  State<GroupOverview> createState() => _GroupOverviewState();
}

class _GroupOverviewState extends State<GroupOverview> {
  late final Group currentGroup;

  @override
  void initState() {
    super.initState();
    currentGroup = widget.group;
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final joinProvider = Provider.of<ForumDataProvider>(context);
    bool isJoined = joinProvider.isJoined(currentGroup.id);
    final forumProvider = Provider.of<ForumDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentGroup.name),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      currentGroup.photo ?? 'assets/images/book_cover7.jpeg',
                    ),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentGroup.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Created: ${_formatDate(currentGroup.creationDate)}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Members: ${currentGroup.members?.length ?? 0}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  currentGroup.description ?? 'No description',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  softWrap: true, // Automatically wrap the text
                  overflow: TextOverflow.visible, // Prevent text overflow
                ),
              ),
              const SizedBox(height: 16),
              isJoined
                  ? OutlinedButton(
                      onPressed: () =>
                          joinProvider.toggleJoinGroup(currentGroup.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Joined',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () =>
                          joinProvider.toggleJoinGroup(currentGroup.id),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Join',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
              const SizedBox(height: 20),
              const Text(
                'Members List:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              currentGroup.members != null && currentGroup.members!.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.4, // Responsive height for member list
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: currentGroup.members!.length,
                        itemBuilder: (context, index) {
                          final userId = currentGroup.members![index];
                          final user = forumProvider.getUserById(userId);
                          return ProfileCard(user: user);
                        },
                      ),
                    )
                  : const Text('No members in this group yet.',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  dynamic getUserById(int userId) {
    return {
      'firstName': 'User $userId',
      'lastName': 'Name $userId',
      'photo': null,
      'id': userId
    };
  }
}
