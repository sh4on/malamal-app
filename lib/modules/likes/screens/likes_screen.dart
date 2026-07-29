import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/likes_controller.dart';

/// wishlist/likes screen using GetView
class LikesScreen extends GetView<LikesController> {
  const LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Wishlist & Likes Screen'),
      ),
    );
  }
}
