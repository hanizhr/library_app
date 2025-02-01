import 'package:flutter/material.dart';
import 'package:library_app/Data/book/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color primary = const Color.fromARGB(255, 51, 65, 85);
Color secendry = const Color.fromARGB(255, 245, 245, 244);
Color gray = const Color.fromARGB(255, 100, 116, 139);
Color background = const Color.fromARGB(255, 248, 250, 252);

int user_id = 0;

List<Book> cartList = [];

class ThemeProvider with ChangeNotifier {
  bool _dark = false;

  bool get dark => _dark;

  Future<void> loadTheme() async {
    final app = await SharedPreferences.getInstance();
    _dark = app.getBool('darkTheme') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _dark = !_dark;
    final app = await SharedPreferences.getInstance();
    await app.setBool('darkTheme', _dark);

    _dark
        ? primary = const Color.fromARGB(255, 226, 232, 240)
        : const Color.fromARGB(255, 32, 41, 53);
    notifyListeners();
  }

  Future<void> changeBook() async {
    notifyListeners();
  }
}
