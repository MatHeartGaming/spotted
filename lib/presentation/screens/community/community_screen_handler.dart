import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/screens/screens.dart';
import 'package:spotted/presentation/widgets/shared/loading_default_widget.dart';

class CommunityScreenHandler extends ConsumerStatefulWidget {
  static const name = 'CommunityScreenHandler';

  final Community? community;
  final String? communityId;
  final String? communityTitle;

  const CommunityScreenHandler({
    super.key,
    required this.communityId,
    this.community,
    this.communityTitle,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreenHandler> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchCommunity();
    });
  }

  void _fetchCommunity() {
    if (widget.community != null) return;
    if (widget.communityId != null) {
      ref
          .read(loadCommunitiesProvider.notifier)
          .loadUsersCommunityById(widget.communityId!)
          .then((communityFound) {
            if (communityFound == null) return;
            ref
                .read(communityScreenCurrentCommunityProvider.notifier)
                .update((state) => communityFound);
          });
      return;
    }
    /*if (widget.communityTitle != null) {
      ref
          .read(loadCommunitiesProvider.notifier)
          .loadUsersCommunityByTitle(widget.communityTitle!)
          .then((communityFound) {
            if (communityFound == null) return;
            ref
                .read(userScreenCurrentUserProvider.notifier)
                .update((state) => communityFound);
          });
      return;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    if (widget.community != null) {
      return CommunityScreen(community: widget.community!);
    }
    final currentCommunity = ref.watch(communityScreenCurrentCommunityProvider);
    final loadUserState = ref.watch(loadUserProvider);
    return loadUserState.isLoadingUser
        ? LoadingDefaultWidget()
        : (currentCommunity.isEmpty)
        ? ErrorScreen(
          message: 'community_screen_community_not_found_error'.tr(),
        )
        : CommunityScreen(community: currentCommunity);
  }
}
