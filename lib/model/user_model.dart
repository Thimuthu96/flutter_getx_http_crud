class User {
  int? id;
  String? name;
  String? email;
  String? contactNumber;

  User({
    this.id,
    this.name,
    this.email,
    this.contactNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact_number': contactNumber,
    };
  }

  User.fromMap(Map<String, dynamic> user) {
    id = user['id'];
    name = user['name'];
    email = user['email'];
    contactNumber = user['contact_number'];
  }
}
