import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:library_app/Data/user/user.dart';
import 'package:library_app/UI/theme.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  // متد بررسی وجود کاربر در دیتابیس
  Future<void> checkIfUserExists(String name) async {
    final url = Uri.parse('http://localhost:3000/login/$name');
    print(url);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        User user =
            User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        print(user.id);
        user_id = user.id;
        // اگر کاربر وجود داشت
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have already registered!')),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookList(
                      user: user,
                    )));
      } else {
        // اگر کاربر وجود نداشت، فرآیند ثبت‌نام را ادامه می‌دهیم
        registerUser(_nameController.text.trim(), _emailController.text.trim());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // متد ثبت‌نام کاربر جدید
  Future<void> registerUser(String name, String email) async {
    final url = Uri.parse('http://localhost:3000/register');

    try {
      setState(() {
        isLoading = true;
      });

      User user = User(id: 1, name: name, email: email);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookList(
                      user: user,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Failed. Try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primary),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign in to continue.',
                  style: TextStyle(fontSize: 16, color: primary),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          fillColor: primary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: primary,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          fillColor: primary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // بررسی می‌کنیم که آیا کاربر قبلاً ثبت‌نام کرده است یا خیر
                                  checkIfUserExists(
                                      _nameController.text.trim());
                                }
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(fontSize: 20, color: primary),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
