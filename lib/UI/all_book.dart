import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/UI/theme.dart';
import 'dart:convert';

import '../Data/book/book.dart';
import 'book_diteils.dart';

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Book> allBooks = []; // All books from API
  List<Book> filteredBooks = []; // Books filtered by search
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  // Fetch all books from API
  Future<void> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/books'));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          allBooks = data.map((bookData) => Book.fromJson(bookData)).toList();
          filteredBooks = allBooks; // Initially show all books
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Fetch books when the page loads
  }

  // Filter books based on search input
  void filterBooks(String query) {
    List<Book> tempBooks = allBooks
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredBooks = tempBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: background,
      appBar: AppBar(
        // backgroundColor: background,
        title: const Text('Books List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Books',
                prefixIconColor: primary,
                fillColor: primary,
                prefixIcon: Icon(
                  Icons.search,
                  color: primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) => filterBooks(value),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Loading
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10.0, // Spacing between columns
                        mainAxisSpacing: 10.0, // Spacing between rows
                        childAspectRatio: 0.7, // Aspect ratio of items
                      ),
                      itemCount: filteredBooks.length, // Filtered books count
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];

                        return Card(
                          color: background,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDiteils(book,
                                            user_id), // Replace '17' with user_id variable
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    book.picture ??
                                        'https://m.media-amazon.com/images/I/61yk+NL+u9L._SL1200_.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 160,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  book.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primary),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'by ${book.author ?? 'Unknown'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: gray,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
