import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/navigation/navigation.dart';
import 'package:spotted/presentation/providers/providers.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

/// A Search screen that queries Users, Posts, and Communities all at once,
/// then displays results separated by section headers.
class HomeSearchScreen extends ConsumerStatefulWidget {
  static const name = 'HomeSearchScreen';

  const HomeSearchScreen({super.key});

  @override
  ConsumerState<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends ConsumerState<HomeSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';

  /// We debounce input so that we don't hammer the repo on every keystroke.
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Classic “debounce” pattern: wait 300ms after the user stops typing:
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = value.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /// 2A) Watch the three search providers with the current _searchQuery
    final usersAsync = ref.watch(searchUsersProvider(_searchQuery));
    final postsAsync = ref.watch(searchPostsProvider(_searchQuery));
    final commsAsync = ref.watch(searchCommunitiesProvider(_searchQuery));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('home_search_screen_search_app_bar_title').tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              // ───── Search Bar ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'home_search_screen_search_bar_placeholder'.tr(),
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  onChanged: _onSearchChanged,
                  onSubmitted: (_) {
                    // Immediately set state on “Enter”
                    setState(() {
                      _searchQuery = _controller.text.trim();
                    });
                  },
                ),
              ),

              // ───── Results ─────────────────────────────────
              Expanded(
                child: ListView(
                  children: [
                    // 2B) Users Section
                    usersAsync.maybeWhen(
                      data: (userList) {
                        if (userList.isEmpty) return const SizedBox();
                        return _buildUsersSection(userList);
                      },
                      loading: () => _buildSectionLoading('users'),
                      error: (err, st) => _buildSectionError('users', err),
                      orElse: () => const SizedBox(),
                    ),

                    // 2C) Posts Section
                    postsAsync.maybeWhen(
                      data: (postList) {
                        if (postList.isEmpty) return const SizedBox();
                        return _buildPostsSection(postList);
                      },
                      loading: () => _buildSectionLoading('posts'),
                      error: (err, st) => _buildSectionError('posts', err),
                      orElse: () => const SizedBox(),
                    ),

                    // 2D) Communities Section
                    commsAsync.maybeWhen(
                      data: (commList) {
                        if (commList.isEmpty) return const SizedBox();
                        return _buildCommunitiesSection(commList);
                      },
                      loading: () => _buildSectionLoading('communities'),
                      error:
                          (err, st) => _buildSectionError('communities', err),
                      orElse: () => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A little helper to show a section header + list of User tiles
  Widget _buildUsersSection(List<UserModel> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(textKey: 'search_results_users_header'.tr()),

        // Show each user in a ListTile (or your own custom widget)
        ...users.map(
          (u) => UserListTile(
            user: u,
            onTap: () => pushToProfileScreen(context, user: u),
          ),
        ),

        const Divider(thickness: 1),
      ],
    );
  }

  /// A loading spinner just under the “Users” header
  Widget _buildSectionLoading(String section) {
    final label =
        {
          'users': 'search_results_users_header'.tr(),
          'posts': 'search_results_posts_header'.tr(),
          'communities': 'search_results_communities_header'.tr(),
        }[section]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(textKey: label),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CircularProgressIndicator(),
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  /// An error row under the section header
  Widget _buildSectionError(String section, Object err) {
    final label =
        {
          'users': 'search_results_users_header'.tr(),
          'posts': 'search_results_posts_header'.tr(),
          'communities': 'search_results_communities_header'.tr(),
        }[section]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(textKey: label),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text('error_loading_results'.tr(args: [err.toString()])),
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  /// A helper to show a section of Post tiles
  Widget _buildPostsSection(List<Post> posts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            pushToPostListScreen(
              context,
              postList: posts,
              searched: _searchQuery.trim(),
            );
          },
          child: _SectionHeader(textKey: 'search_results_posts_header'.tr()),
        ),
        ...posts.map(
          (p) => PostListTile(
            post: p,
            onTap:
                () => pushToPostListScreen(
                  context,
                  postList: [p],
                  searched: p.title,
                ),
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  /// A helper to show a section of Community tiles
  Widget _buildCommunitiesSection(List<Community> comms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(textKey: 'search_results_communities_header'.tr()),
        ...comms.map(
          (c) => CommunityListTile(
            community: c,
            onTap: () => pushToCommunityScreen(context, community: c),
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}

/// A simple, reusable widget for section headers
class _SectionHeader extends StatelessWidget {
  final String textKey;
  const _SectionHeader({required this.textKey});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colors.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        textKey,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: colors.onTertiaryContainer,
        ),
      ),
    );
  }
}
