import 'package:flutter/material.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/widgets/group_card.dart';
import 'package:provider/provider.dart';
import 'package:inkora/providers/forum_data_provider.dart';

class GroupsResult extends StatelessWidget {
  final String query;

  const GroupsResult({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    // Get the ForumDataProvider to access the groups data
    final forumProvider = Provider.of<ForumDataProvider>(context);
    
    // Get groups from the provider instead of hardcoding them
    final List<Group> groups = forumProvider.groups;
  
    // Filter groups based on the search query
    List<Group> filteredGroups = groups.where((group) {
      return group.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return filteredGroups.isEmpty
        ? Center(child: Text("No Groups found for '$query'"))
        : ListView.builder(
            itemCount: filteredGroups.length,
            itemBuilder: (context, index) {
              return GroupCard(group: filteredGroups[index]);
            },
          );
  }
}
