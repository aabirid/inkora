import 'package:flutter/material.dart';

int itemCount = 20;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Chapter ${(index + 1)}'),
          leading: Icon(Icons.book_rounded),
          trailing: Icon(Icons.arrow_right_rounded),
          onTap: () {
            debugPrint('Chapter ${(index + 1)} !!!!!');
          },
        );
      },
    );
  }
}
