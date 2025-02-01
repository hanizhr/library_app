class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // Convert User to Map (for inserting into SQLite or sending to server)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Convert Map to User (for reading from API response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Ensure the response includes the 'id' field
      name: json['name'],
      email: json['email'],
    );
  }
}
