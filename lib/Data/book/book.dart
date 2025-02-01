class Book {
  int id;
  String title;
  int price;
  int owner;
  int Bby;
  String? author;
  String? publication_date;
  String? picture;
  String? genre;
  Book(
      {required this.id,
      required this.title,
      required this.price,
      required this.owner,
      required this.Bby,
      this.author,
      this.publication_date,
      this.picture,
      this.genre});
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      price: json['price'] ?? 0,
      owner: json['owner'] ?? 0,
      Bby: json['Bby'] ?? 0,
      author: json['author'], // Nullable field
      publication_date: json['publication_date'] != null
          ? DateTime.parse(json['publication_date']).toString() // Parse date
          : null, // Nullable field
      picture: json['picture'], // Nullable field
      genre: json['genre'], // New field
    );
  }
}
