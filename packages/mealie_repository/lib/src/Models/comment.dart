part of '../mealie_repository.dart';

class Comment extends Equatable {
  Comment({
    required this.recipeId,
    required this.text,
    required this.id,
    required this.createdAt,
    required this.updateAt,
    required this.userId,
    required this.user,
  });

  final String recipeId;
  final String text;
  final String id;
  final String createdAt;
  final String updateAt;
  final String userId;
  final User user;

  static Comment fromData({required Map<String, dynamic> data}) {
    return Comment(
      recipeId: data['receipId'],
      text: data['text'],
      id: data['id'],
      createdAt: data['createdAt'],
      updateAt: data['updateAt'],
      userId: data['userId'],
      user: User.fromMealieResponse(data: data['user'], refreshToken: ""),
    );
  }

  Comment copyWith({
    String? recipeId,
    String? text,
    String? id,
    String? createdAt,
    String? updateAt,
    String? userId,
    User? user,
  }) {
    return Comment(
      recipeId: recipeId ?? this.recipeId,
      text: text ?? this.text,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
      userId: userId ?? this.userId,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['recipeId'] = this.recipeId;
    json['text'] = this.text;
    json['id'] = this.id;
    json['createdAt'] = this.createdAt;
    json['updateAt'] = this.updateAt;
    json['userId'] = this.userId;
    json['user'] = this.user.toJson();
    return json;
  }

  @override
  List<Object?> get props => [
        recipeId,
        text,
        id,
        createdAt,
        updateAt,
        userId,
        user,
      ];
}
