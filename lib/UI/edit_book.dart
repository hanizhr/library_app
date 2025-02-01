import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/UI/theme.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../Data/book/book.dart';

class EditBookPage extends StatefulWidget {
  final Book bookData; // Pass the book data
  final int userId;

  EditBookPage({required this.bookData, required this.userId, super.key});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _bbyController;
  late TextEditingController _genreController;
  late TextEditingController _authorController;
  late TextEditingController _publicationDateController;
  late TextEditingController _pictureController;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with the existing book data
    _titleController = TextEditingController(text: widget.bookData.title);
    _priceController =
        TextEditingController(text: widget.bookData.price.toString());
    _bbyController = TextEditingController(text: (-1).toString());
    _genreController = TextEditingController(text: widget.bookData.genre);
    _authorController = TextEditingController(text: widget.bookData.author);
    _publicationDateController =
        TextEditingController(text: widget.bookData.publication_date);
    _pictureController = TextEditingController(text: widget.bookData.picture);
  }

  Future<void> _updateBook() async {
    final String apiUrl =
        'http://localhost:3000/editBook/${widget.bookData.id}'; // Assuming book_id is available

    final Map<String, dynamic> updatedBookData = {
      'title': _titleController.text,
      'price': int.tryParse(_priceController.text) ?? 0,
      'owner': widget.userId,
      'Bby': _bbyController.text,
      'genre': _genreController.text,
      'author': _authorController.text,
      'publication_date': _publicationDateController.text,
      'picture': _pictureController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedBookData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book updated successfully!')),
        );
        Navigator.pop(context); // Go back to the previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update book.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _bbyController,
                decoration: InputDecoration(labelText: 'Bby'),
              ),
              TextField(
                controller: _genreController,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: _publicationDateController,
                decoration: InputDecoration(labelText: 'Publication Date'),
              ),
              TextField(
                controller: _pictureController,
                decoration: InputDecoration(labelText: 'Picture URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _updateBook;
                  context.read<ThemeProvider>().changeBook();
                },
                child: Text('Update Book for User: ${widget.userId}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
