import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:library_app/Data/book/book.dart';
import 'package:library_app/Data/user/user.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/UI/checCart.dart';
import 'package:library_app/UI/mybook.dart';
import 'package:library_app/UI/theme.dart';
import 'package:provider/provider.dart';
import 'add_book.dart';
import 'view_cart.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  User user;
  Profile(this.user, {super.key});

  Future<void> checkIfUserExists(String name) async {
    final url = Uri.parse('http://localhost:3000/login/$name');
    print(url);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        user = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        print(user.id);
        // اگر کاربر وجود داشت
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Book>> fetchBooks(int userId) async {
    final String apiUrl = 'http://localhost:3000/books/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // تبدیل JSON به لیست Book
        List<dynamic> data = jsonDecode(response.body);
        List<Book> books = data.map((json) => Book.fromJson(json)).toList();
        return books;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool thm = context.read<ThemeProvider>().dark;
    return Scaffold(
      // backgroundColor: background,
      appBar: AppBar(
        // backgroundColor: background,
        title: const Text('profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddBookPage(user.id)));
                  },
                  child: Text(
                    'add book',
                    style: TextStyle(fontSize: 16, color: primary),
                  )),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartPage(
                                  userId: user.id,
                                )));
                  },
                  child: Text(
                    'view old carts',
                    style: TextStyle(fontSize: 16, color: primary),
                  )),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () async {
                    // int userId = int.tryParse(user.email) ?? 0;
                    int userId = user.id;
                    List<Book> book = await fetchBooks(userId);
                    print(book);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Books(
                          books: book,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'my books',
                    style: TextStyle(fontSize: 16, color: primary),
                  )),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckCart(
                          userId: user_id, // Example user ID
                          books: cartList, // Example book IDs
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'cart',
                    style: TextStyle(fontSize: 16, color: primary),
                  )),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        thm ? Icons.nightlight : Icons.sunny,
                        color: primary,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      thm ? const Text('Dark') : const Text('Light'),
                    ],
                  ),
                  Switch(
                    value: thm,
                    activeColor: primary,
                    onChanged: (value) {
                      context.read<ThemeProvider>().toggleTheme();
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'about me:',
                style: TextStyle(
                    fontSize: 24, color: primary, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'name :',
                    style: TextStyle(fontSize: 16, color: primary),
                  ),
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 16, color: primary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'email :',
                    style: TextStyle(fontSize: 16, color: primary),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16, color: primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
