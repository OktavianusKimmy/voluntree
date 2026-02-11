import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Voluntree/screens/auth/views/welcome_screen.dart';
import 'package:Voluntree/screens/home/widgets/feed_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Voluntree/screens/home/widgets/post_card.dart';
import 'package:Voluntree/models/post_models.dart';
import 'package:Voluntree/theme/app_colors.dart';

import 'create_post_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bone,

      /// 🌿 APP BAR (like design)
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.nature, color: cream),
            const SizedBox(width: 8),
            const Text(
              'VOLUNTREE',
              style: TextStyle(
                color: bone,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: cream),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: cream),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),

      /// 📰 FEED (LOGIC UNCHANGED)
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No posts yet"));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 80),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: posts[index].data() as Map<String, dynamic>,
              );
            },
          );
        },
      ),

      /// ➕ FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: oliveGreen,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
        },
      ),

      /// 🧭 BOTTOM NAV (matching design)
      bottomNavigationBar: Container(
        color: oliveGreen,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: GNav(
          selectedIndex: _selectedIndex,
          gap: 8,
          color: darkGreen,
          activeColor: Colors.white,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          tabBackgroundColor: oliveGreen.withOpacity(0.15),
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(icon: Icons.home, text: 'Beranda'),
            GButton(icon: Icons.event, text: 'Aktivitas'),
            GButton(icon: Icons.volunteer_activism, text: 'Donasi'),
            GButton(icon: Icons.person, text: 'Profil'),
          ],
        ),
      ),
    );
  }
}