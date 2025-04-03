import 'package:flutter/material.dart';
import 'package:inkora/models/booklist.dart';
import 'package:inkora/providers/auth_provider.dart';
import 'package:inkora/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooklistDialog extends StatefulWidget {
  final int bookId;

  const BooklistDialog({Key? key, required this.bookId}) : super(key: key);

  @override
  _BooklistDialogState createState() => _BooklistDialogState();
}

class _BooklistDialogState extends State<BooklistDialog> {
  final ApiService _apiService = ApiService();
  final TextEditingController _titleController = TextEditingController();
  
  List<Booklist> _booklists = [];
  bool _isLoading = true;
  bool _isCreatingBooklist = false;
  String _visibility = 'private';
  int _userId = 1; // Default value
  
  @override
  void initState() {
    super.initState();
    _loadUserIdAndBooklists();
  }
  
  Future<void> _loadUserIdAndBooklists() async {
    try {
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.user != null) {
        setState(() {
          _userId = authProvider.user!.id;
        });
      }
      // Fetch user's booklists
      final booklists = await _apiService.getUserBooklists(_userId);
      
      if (mounted) {
        setState(() {
          _booklists = booklists;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading booklists: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load booklists')),
        );
      }
    }
  }
  
  Future<void> _addToBooklist(int booklistId) async {
    try {
      final success = await _apiService.addBookToBooklist(_userId, booklistId, widget.bookId);
      
      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book added to booklist successfully')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add book to booklist')),
        );
      }
    } catch (e) {
      print('Error adding book to booklist: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
  
  Future<void> _createBooklist() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title for the booklist')),
      );
      return;
    }
    
    setState(() {
      _isCreatingBooklist = true;
    });
    
    try {
      final newBooklist = await _apiService.createBooklist(_userId, _titleController.text.trim(), _visibility);
      
      if (newBooklist != null && mounted) {
        // Add book to the newly created booklist
        await _apiService.addBookToBooklist(_userId, newBooklist.id, widget.bookId);
        
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book added to new booklist successfully')),
        );
      } else if (mounted) {
        setState(() {
          _isCreatingBooklist = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create booklist')),
        );
      }
    } catch (e) {
      print('Error creating booklist: $e');
      if (mounted) {
        setState(() {
          _isCreatingBooklist = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
  
  void _showCreateBooklistForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Booklist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Booklist Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            SizedBox(height: 16),
            Text('Visibility:'),
            RadioListTile<String>(
              title: Text('Private'),
              value: 'private',
              groupValue: _visibility,
              onChanged: (value) {
                setState(() {
                  _visibility = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Public'),
              value: 'public',
              groupValue: _visibility,
              onChanged: (value) {
                setState(() {
                  _visibility = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isCreatingBooklist ? null : () {
                    Navigator.pop(context);
                    _createBooklist();
                  },
                  child: _isCreatingBooklist
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Create'),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Add to Booklist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(height: 1),
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  )
                : _booklists.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text('You don\'t have any booklists yet.'),
                      )
                    : Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _booklists.length,
                          itemBuilder: (context, index) {
                            final booklist = _booklists[index];
                            return ListTile(
                              title: Text(booklist.title),
                              subtitle: Text(
                                booklist.visibility == 'public' ? 'Public' : 'Private',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () => _addToBooklist(booklist.id),
                            );
                          },
                        ),
                      ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Create new booklist'),
              onTap: _showCreateBooklistForm,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}

