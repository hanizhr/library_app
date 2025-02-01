import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:library_app/Data/book/book.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/UI/theme.dart';
import 'book_diteils.dart';
import 'edit_book.dart';

class Books extends StatelessWidget {
  final List<Book> books;

  Books({required this.books});

  @override
  Widget build(BuildContext context) {
    Future<void> deleteBook(int bookId) async {
      final url = Uri.parse(
          'http://localhost:3000/deleteBook/$bookId'); // Replace with your server URL

      try {
        final response = await http.delete(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
          // Refresh the book list
        } else {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(errorData['message'] ?? 'Failed to delete book')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Books')),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                                builder: (context) =>
                                    BookDiteils(book, user_id)));
                      },
                      onLongPress: () {
                        deleteBook(book.id);
                      },
                      child: Image.network(
                        book.picture ??
                            'https://m.media-amazon.com/images/I/61yk+NL+u9L._SL1200_.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      book.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'by ${book.author}',
                          style: TextStyle(fontSize: 14, color: primary),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBookPage(
                                    bookData:
                                        book, // Pass the existing book data here
                                    userId: user_id, // Pass the user id
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: primary,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
