
//   // Function to add a book to the cart
//   import 'package:library_app/Data/cart/cart.dart';

// import '../book/book.dart';

// Future<void> addToCart(Book book) async {
//    Cart currentCart;
//     // if (currentCart == null) {
//     //   // If no cart exists, create a new cart
//     //   currentCart = Cart(cartId: 1, items: []);
//     // }

//     // Check if the book already exists in the cart
//     bool exists = false;
//     for (var item in currentCart!.items) {
//       if (item.bookId == book.id) {
//         exists = true;
//         break;
//       }
//     }

//     if (exists) {
//       // Update the quantity of the book in the cart
//       setState(() {
//         currentCart!.items
//             .firstWhere((item) => item.bookId == book.id)
//             .quantity++;
//       });
//     } else {
//       // Add the book to the cart
//       setState(() {
//         currentCart!.items.add(CartItem(bookId: book.id, quantity: 1));
//       });
//     }

//     // Send the book to the backend to add it to the cart
//     await sendBookToCart(book);
//   }

//   // Function to send the book to the backend
//   Future<void> sendBookToCart(Book book) async {
//     final url = Uri.parse('http://your-backend-url/addToCart'); // Your backend URL
//     final response = await http.post(url, body: {
//       'cart_id': currentCart!.cartId.toString(),
//       'book_id': book.id.toString(),
//       'quantity': '1',
//     });

//     if (response.statusCode == 200) {
//       print("Book added to cart successfully");
//     } else {
//       print("Failed to add book to cart");
//     }
//   }
// }