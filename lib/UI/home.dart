import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/UI/profile.dart';
import 'dart:convert';

import '../Data/user/user.dart';
import 'all_book.dart';
import 'theme.dart';

class BookList extends StatefulWidget {
  final User user;

  const BookList({super.key, required this.user});
  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<dynamic> books = [];
  List<dynamic> authors = [];
  bool isLoading = true; // Show loading indicator initially

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Fetch books when the app starts
    fetchAuthors(); // Fetch authors when the app starts
  }

  // Fetch books from API
  Future<void> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/books'));

      if (response.statusCode == 200) {
        // Parse JSON response
        final data = json.decode(response.body);
        setState(() {
          books = data; // Store books in the list
          isLoading = false; // Stop loading
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  // Fetch authors from API
  Future<void> fetchAuthors() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/users'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          authors = data; // Store authors in the list
        });
      } else {
        throw Exception('Failed to load authors');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: background,
      appBar: AppBar(
        // backgroundColor: background,
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Profile(widget.user)));
          }),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "hello, ${widget.user.name}👋",
                    style: TextStyle(fontSize: 20, color: primary),
                  ),
                  Text(
                    "finde your favorite category !",
                    style: TextStyle(fontSize: 20, color: primary),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Books',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primary),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BooksPage()));
                          },
                          child: const Text(
                            'viwe all',
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Horizontal list of books
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];

                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  book['picture'] ??
                                      'https://m.media-amazon.com/images/I/61yk+NL+u9L._SL1200_.jpg', // Default image if null
                                  height: 180,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  book['title'] ?? 'No Title', // Book title
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: primary),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'All Users',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary),
                  ),
                  const SizedBox(height: 10),
                  // Horizontal list of authors
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: authors.length,
                      itemBuilder: (context, index) {
                        final author = authors[index];

                        return Container(
                          width: 70,
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 25,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                author['name'] ?? 'Unknown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: primary),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
