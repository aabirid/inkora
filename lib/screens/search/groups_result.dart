import 'package:flutter/material.dart';
import 'package:inkora/models/group.dart';
import 'package:inkora/services/api_service.dart';
import 'package:inkora/widgets/group_card.dart';

class GroupsResult extends StatefulWidget {
  final String query;

  const GroupsResult({super.key, required this.query});

  @override
  _GroupsResultState createState() => _GroupsResultState();
}

class _GroupsResultState extends State<GroupsResult> {
  late Future<List<Group>> _groupsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _groupsFuture = _apiService.searchGroups(widget.query);
  }

  @override
  void didUpdateWidget(GroupsResult oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        _groupsFuture = _apiService.searchGroups(widget.query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Group>>(
      future: _groupsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No groups found for '${widget.query}'"));
        } else {
          final groups = snapshot.data!;
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return GroupCard(group: groups[index]);
            },
          );
        }
      },
    );
  }
}

