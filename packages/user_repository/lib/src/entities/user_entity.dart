class MyUserEntity{
  String userId;
  String name;
  String email;
  String password;

  MyUserEntity(
  {
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, Object?> toDocument(){
    return{
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc){
    return MyUserEntity(
      userId: doc['userId'],
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
    );
  }
}