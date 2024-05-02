part of '../mealie_repository.dart';

class Favorites extends Equatable {
  Favorites({
    required this.recipeId,
    required this.rating,
    required this.isFavorite,
    required this.userId,
    required this.id,
  });
  final String recipeId;
  final double? rating;
  final bool isFavorite;
  final String userId;
  final String id;

  static Favorites? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Favorites(
      recipeId: data['recipeId'],
      rating: data['rating'],
      isFavorite: data['isFavorite'],
      userId: data['userId'],
      id: data['id'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['recipeId'] = this.recipeId;
    if (this.rating != null) json['rating'] = this.rating;
    json['isFavorite'] = this.isFavorite;
    json['userId'] = this.userId;
    json['id'] = this.id;
    return json;
  }

  @override
  List<Object?> get props => [
        recipeId,
        rating,
        isFavorite,
        userId,
        id,
      ];
}
