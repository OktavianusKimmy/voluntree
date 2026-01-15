
import '../entities/user_entity.dart';

class MyUser {
  String userId;
  String email;
  String password;
  String name;

  MyUser({
    required this.userId,
    required this.email,
    required this.password,
    required this.name,
  });

  static final empty = MyUser(userId: '', email: '', password:
  '', name: '');

  MyUser copyWith({
    String? userId,
    String? email,
    String? password,
    String? name,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      password: password,
      name: name,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId,
        email: entity.email,
        password: entity.password,
        name: entity.name);
  }

}