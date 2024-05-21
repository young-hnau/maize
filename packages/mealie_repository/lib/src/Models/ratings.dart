part of '../mealie_repository.dart';

class Rating extends Equatable {
  Rating({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.isFavorite,
    required this.rating,
  });

  final String id;
  final String recipeId;
  final String userId;
  final bool isFavorite;
  final double? rating;

  static Rating? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Rating(
      id: data['id'],
      recipeId: data['recipeId'],
      userId: data['userId'],
      isFavorite: data['isFavorite'],
      rating: data['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    json['recipeId'] = this.recipeId;
    json['userId'] = this.userId;
    json['isFavorite'] = this.isFavorite;
    if (this.rating != null) json['rating'] = this.rating;
    return json;
  }

  @override
  List<Object?> get props => [id, recipeId, userId, isFavorite, rating];
}
