import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String imageUrl;
  final String caption;
  final DateTime createdAt;
  final int likes;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    required this.likes,
  });

  factory PostModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      userId: data['userId'],
      username: data['username'],
      imageUrl: data['imageUrl'],
      caption: data['caption'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
    );
  }
}
