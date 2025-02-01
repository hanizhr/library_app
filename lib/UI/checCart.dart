import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:library_app/Data/book/book.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

class CheckCart extends StatefulWidget {
  final int userId;
  final List<Book> books;

  CheckCart({super.key, required this.userId, required this.books});

  @override
  _CheckCartState createState() => _CheckCartState();
}

class _CheckCartState extends State<CheckCart> {
  late List<Book> books;

  @override
  void initState() {
    super.initState();
    books = widget.books;
  }

  Future<void> addToCart(int buyerId, Book book, int quantity) async {
    final String url = 'http://localhost:3000/addToCart';
    final Map<String, dynamic> bookData = {
      'user_id': buyerId,
      'book_id': book.id,
      'quantity': quantity,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookData),
      );

      if (response.statusCode == 200) {
        // Handle success (add to local cart)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${book.title} added to cart successfully')),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add book to cart')),
        );
      }
    } catch (error) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: background,
      appBar: AppBar(title: const Text('Book List')),
      body: books.isEmpty
          ? const Center(child: Text('No books available'))
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: book.picture != null && book.picture!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(book.picture!,
                                  width: 50, height: 50, fit: BoxFit.cover),
                            )
                          : const Icon(Icons.book, size: 50),
                      title: Text(
                        book.title,
                        style: TextStyle(
                            color: primary, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Author: ${book.author}',
                        style: TextStyle(color: primary),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          addToCart(user_id, book, 1);
                          cartList.remove(book);
                          context.read<ThemeProvider>().changeBook();
                        },
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(color: primary),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
