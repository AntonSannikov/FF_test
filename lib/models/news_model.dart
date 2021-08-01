import 'package:meta/meta.dart';

class NewsModel {
  int? id;
  Map<String, dynamic>? meta;
  dynamic? caption;
  List? tags;
  dynamic? location;
  int? userId;
  String? photoId;
  String? createdAt;
  String? updatedAt;
  Map<String, dynamic>? photo;
  Map<String, dynamic>? user;

  NewsModel(
      {@required this.id,
      @required this.meta,
      @required this.caption,
      @required this.tags,
      @required this.location,
      @required this.userId,
      @required this.photoId,
      @required this.createdAt,
      @required this.updatedAt,
      @required this.photo,
      @required this.user});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
        id: json['id'],
        meta: json['meta'],
        caption: json['caption'],
        tags: json['tags'],
        location: json['location'],
        userId: json['userId'],
        photoId: json['photoId'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        photo: json['photo'],
        user: json['user']);
  }
}
