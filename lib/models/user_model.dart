class User {
  String? id;
  String? contact;
  String? username;
  String? updatedAt;

  Map<String, dynamic>? details;

  User({
    this.id,
    this.contact,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> value) {
    return User(
      id: value["id"],
      contact: value["contact"],
      username: value['username'],
    );
  }
}
