import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/UI/theme.dart';

import '../Data/book/book.dart';

// CartPage widget where we fetch and display cart items
class CartPage extends StatefulWidget {
  final int userId;

  CartPage({required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Book> _cartBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> removeFromCart(int userId, int bookId) async {
    const String url = 'http://localhost:3000/removeFromCart';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId, 'book_id': bookId}),
      );

      if (response.statusCode == 200) {
        print('Book removed from cart successfully');
      } else {
        print('Failed to remove book from cart: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fetch the cart items from the backend API
  Future<void> fetchCartItems() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/getCart/${widget.userId}'));

    if (response.statusCode == 200) {
      final List<dynamic> data =
          json.decode(response.body); // List of cart items

      List<Book> books = [];
      for (var cartItem in data) {
        final bookResponse = await http.get(
            Uri.parse('http://localhost:3000/getBook/${cartItem['book_id']}'));

        if (bookResponse.statusCode == 200) {
          final List<dynamic> bookData =
              json.decode(bookResponse.body); // bookData is a List

          if (bookData.isNotEmpty) {
            // Get the first book object from the list and parse it
            books.add(
                Book.fromJson(bookData[0])); // Add the first book in the list
          } else {
            print('No books found for book_id ${cartItem['book_id']}');
          }
        }
      }

      setState(() {
        _cartBooks = books;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartBooks.isEmpty
              ? const Center(child: Text('No items in the cart.'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: _cartBooks.length,
                  itemBuilder: (context, index) {
                    final book = _cartBooks[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: InkWell(
                        onLongPress: () {
                          removeFromCart(user_id, book.id);
                        },
                        child: Card(
                          elevation: 5.0,
                          child: Column(
                            children: [
                              book.picture != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(book.picture!,
                                            height: 100,
                                            width: 80,
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : const Icon(Icons.book,
                                      size: 80), // Fallback if no picture
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(book.title,
                                    style: TextStyle(color: primary),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Price: \$${book.price}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primary)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CartPage(userId: 17), // Replace with your user ID
  ));
}
