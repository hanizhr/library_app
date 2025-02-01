import 'package:flutter/material.dart';
import 'package:library_app/Data/book/book.dart';
import 'package:library_app/UI/theme.dart';

// ignore: must_be_immutable
class BookDiteils extends StatelessWidget {
  Book book;
  int buyerId;
  BookDiteils(this.book, this.buyerId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cartList.add(book);
          Navigator.pop(context);
        },
        child: Icon(
          Icons.add,
          color: primary,
        ),
      ),
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    book.picture ??
                        "https://m.media-amazon.com/images/I/61yk+NL+u9L._SL1200_.jpg",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'name: ',
                    style: TextStyle(fontSize: 24, color: primary),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    book.title,
                    style: TextStyle(fontSize: 20, color: primary),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'price: ',
                    style: TextStyle(fontSize: 24, color: primary),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    book.price.toString(),
                    style: TextStyle(fontSize: 20, color: primary),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'publication date: ',
                    style: TextStyle(fontSize: 24, color: primary),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    book.publication_date.toString(),
                    style: TextStyle(fontSize: 20, color: primary),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'author: ',
                    style: TextStyle(fontSize: 24, color: primary),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    book.author.toString(),
                    style: TextStyle(fontSize: 20, color: primary),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
