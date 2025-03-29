import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatefulWidget {
  final User user;

  const ProfileEditPage({super.key, required this.user});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late User _editedUser;
  final _formKey = GlobalKey<FormState>();
  File? _newProfileImage;

  @override
  void initState() {
    super.initState();
    _editedUser = widget.user.copyWith(); // Copy user to avoid modifying original until saved
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path); // Set the new profile image
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if a new profile image is selected and update accordingly
      _editedUser = _editedUser.copyWith(photo: _newProfileImage?.path ?? _editedUser.photo);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success = await authProvider.updateProfile(
        username: _editedUser.username,
        bio: _editedUser.bio,
        photoPath: _editedUser.photo,
      );

      if (success) {
        Navigator.pop(context, _editedUser); // Pass back the updated user to the profile page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text("Save"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _newProfileImage != null
                      ? FileImage(_newProfileImage!) // Display new image if selected
                      : (_editedUser.photo != null
                          ? (_editedUser.photo!.startsWith("http")
                              ? NetworkImage(_editedUser.photo!) // If it's a network image
                              : FileImage(File(_editedUser.photo!)) // If it's a local file
                          )
                          : const AssetImage("assets/images/profile_default.jpeg")
                      ) as ImageProvider,
                  child: const Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _editedUser.username,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) => value!.isEmpty ? "Enter your username" : null,
                onSaved: (value) => _editedUser = _editedUser.copyWith(username: value),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _editedUser.bio,
                decoration: const InputDecoration(labelText: "Bio"),
                maxLines: 2,
                onSaved: (value) => _editedUser = _editedUser.copyWith(bio: value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
