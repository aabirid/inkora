import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:inkora/models/user.dart';

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
        _newProfileImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Apply new profile picture if changed
      final updatedUser = _editedUser.copyWith(
        photo: _newProfileImage != null ? _newProfileImage!.path : _editedUser.photo,
      );

      Navigator.pop(context, updatedUser); // Return updated user to MyProfilePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"),
      actions: [
        TextButton(onPressed: _saveProfile,
                child: const Text("Save"),)
      ],),
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
                          ? FileImage(File(_editedUser.photo!)) // Display existing image if available
                          : const AssetImage("assets/images/profile_default.jpeg")) as ImageProvider,
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
                initialValue: _editedUser.username, // Add username field
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) => value!.isEmpty ? "Enter your username" : null,
                onSaved: (value) => _editedUser = _editedUser.copyWith(username: value),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _editedUser.bio, // Add bio field
                decoration: const InputDecoration(labelText: "Bio"),
                maxLines: 2, // Allow multiline bio input
                onSaved: (value) => _editedUser = _editedUser.copyWith(bio: value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
