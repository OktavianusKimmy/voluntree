class MyUserEntity {
  String userId;
  String name;
  String email;

  MyUserEntity({
    required this.userId,
    required this.name,
    required this.email,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'],
      name: doc['name'],
      email: doc['email'],
    );
  }
}
