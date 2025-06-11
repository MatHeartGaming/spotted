import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';

Future<void> actionCommunityTap(WidgetRef ref, String? postedIn) async {
    logger.i('Community: $postedIn');
    if (postedIn == null) return;
    final loadCommunity = ref.read(loadCommunitiesProvider.notifier);
    loadCommunity.loadUsersCommunityById(postedIn).then((community) {
      if (community == null || community.isEmpty) return;
      logger.i('Community: $community');
      if (ref.context.mounted) {
        pushToCommunityScreen(ref.context, community: community);
      }
    });
  }