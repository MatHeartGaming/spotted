import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  final Community community;
  const CommunityScreen({super.key, required this.community});

  @override
  CommunityScreenState createState() => CommunityScreenState();
}

class CommunityScreenState extends ConsumerState<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    final community = widget.community;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(body: Center(child: Text(community.title))),
    );
  }
}
