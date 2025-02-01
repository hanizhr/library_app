import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:library_app/UI/theme.dart';
import 'package:library_app/main.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddBookPage extends StatefulWidget {
  late int id;
  AddBookPage(int id, {super.key}) {
    this.id = id;
  }

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  TextEditingController _bbyController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publicationDateController =
      TextEditingController();
  final TextEditingController _pictureController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _bbyController = TextEditingController(text: (-1).toString());
  }

  Future<void> _addBook() async {
    final String apiUrl = 'http://localhost:3000/addBook';

    final Map<String, dynamic> bookData = {
      'title': _titleController.text,
      'price': int.tryParse(_priceController.text) ?? 0,
      'owner': widget.id,
      'Bby': _bbyController.text,
      'genre': _genreController.text,
      'author': _authorController.text,
      'publication_date': _publicationDateController.text,
      'picture': _pictureController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add book.')),
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
      // backgroundColor: background,
      appBar: AppBar(title: const Text('Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(
                height: 16,
              ),
              TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number),
              const SizedBox(
                height: 16,
              ),
              TextField(
                  controller: _genreController,
                  decoration: const InputDecoration(labelText: 'Genre')),
              const SizedBox(
                height: 16,
              ),
              TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author')),
              const SizedBox(
                height: 16,
              ),
              TextField(
                  controller: _publicationDateController,
                  decoration:
                      const InputDecoration(labelText: 'Publication Date')),
              const SizedBox(
                height: 16,
              ),
              TextField(
                  controller: _pictureController,
                  decoration: const InputDecoration(labelText: 'Picture URL')),
              const SizedBox(height: 42),
              ElevatedButton(
                onPressed: () {
                  _addBook;
                  context.read<ThemeProvider>().changeBook();
                },
                child: Text(
                  'Add Book to user : ${widget.id}',
                  style: TextStyle(
                      color: primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
