import 'package:flutter/material.dart';
import 'package:spotted/domain/models/models.dart';

class CommunityScreen extends StatelessWidget {
  final Community community;

  const CommunityScreen({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(community.title)));
  }
}
