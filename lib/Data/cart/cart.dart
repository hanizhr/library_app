import 'package:library_app/Data/book/book.dart';

class Cart {
  final int userid;
  List<Book> items;

  Cart({required this.userid, required this.items});
}
