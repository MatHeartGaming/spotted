import 'package:flutter/material.dart';
import 'package:spotted/domain/models/models.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Profile Screen ${user.username}')));
  }
}
