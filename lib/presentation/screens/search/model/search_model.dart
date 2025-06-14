// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:spotted/domain/models/models.dart';

class SearchModel {
  final UserModel? user;
  final Post? post;
  final Community? community;

  SearchModel({this.user, this.post, this.community});

  bool get isPost => post != null;
  bool get isUser => user != null && !(user?.isEmpty ?? false);
  bool get isCommunity => community != null && !(community?.isEmpty ?? false);

  @override
  bool operator ==(covariant SearchModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.user == user &&
      other.post == post &&
      other.community == community;
  }

  @override
  int get hashCode => user.hashCode ^ post.hashCode ^ community.hashCode;

  @override
  String toString() => 'SearchModel(user: $user, post: $post, community: $community)';

  SearchModel copyWith({
    UserModel? user,
    Post? post,
    Community? community,
  }) {
    return SearchModel(
      user: user ?? this.user,
      post: post ?? this.post,
      community: community ?? this.community,
    );
  }
}
