import 'package:flutter/material.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/services/api_service.dart';
import 'package:inkora/widgets/profile_card.dart';

class ProfilesResult extends StatefulWidget {
  final String query;

  const ProfilesResult({super.key, required this.query});

  @override
  _ProfilesResultState createState() => _ProfilesResultState();
}

class _ProfilesResultState extends State<ProfilesResult> {
  late Future<List<User>> _profilesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _profilesFuture = _apiService.searchProfiles(widget.query);
  }

  @override
  void didUpdateWidget(ProfilesResult oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        _profilesFuture = _apiService.searchProfiles(widget.query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _profilesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No profiles found for '${widget.query}'"));
        } else {
          final profiles = snapshot.data!;
          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              return ProfileCard(user: profiles[index]);
            },
          );
        }
      },
    );
  }
}

