import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Voluntree/theme/app_colors.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  final TextEditingController descController = TextEditingController();

  Future<void> uploadPost() async {
    // 1️⃣ Check image
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    // 2️⃣ Check user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      // 3️⃣ Show loading
      setState(() {
        isLoading = true;
      });

      // 4️⃣ Create post ID
      final postId =
          FirebaseFirestore.instance
              .collection('posts')
              .doc()
              .id;

      // 5️⃣ Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child('$postId.jpg');

      await storageRef.putFile(_image!);

      // 6️⃣ Get image URL
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set({
        'userId': user.uid,
        'username': user.displayName ?? user.email ?? 'Anonymous',
        'imageUrl': imageUrl,
        'caption': descController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 8️⃣ Success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post uploaded successfully")),
      );

      // 9️⃣ Clear form and go back
      descController.clear();
      setState(() {
        _image = null;
      });
      Navigator.pop(context);
    } catch (e) {
      debugPrint("UPLOAD POST ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0.5,
        title: const Text(
          'New Post',
          style: TextStyle(color: bone,
          fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: bone),
        actions: [
          TextButton(
            onPressed: isLoading ? null : uploadPost,
            child: isLoading
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text(
              'Share',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: bone
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [

          /// IMAGE PICKER / PREVIEW
          GestureDetector(
            onTap: pickImage,
            child: Container(
              width: double.infinity,
              height: 320,
              color: const Color(0xFFF1F1F1),
              child: _image == null
                  ? const Center(
                child: Icon(Icons.add_a_photo, size: 40),
              )
                  : Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// CAPTION
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFDBDBDB),
                  child: Icon(Icons.person, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: descController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}