part of '../mealie_repository.dart';

class Nutrition extends Equatable {
  Nutrition({
    this.calories,
    this.fatContent,
    this.proteinContent,
    this.carbohydrateContent,
    this.fiberContent,
    this.sodiumContent,
    this.sugarContent,
  });

  final String? calories;
  final String? fatContent;
  final String? proteinContent;
  final String? carbohydrateContent;
  final String? fiberContent;
  final String? sodiumContent;
  final String? sugarContent;

  static Nutrition? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Nutrition(
      calories: data['calories'],
      fatContent: data['fatContent'],
      proteinContent: data['proteinContent'],
      carbohydrateContent: data['carbohydrateContent'],
      fiberContent: data['fiberContent'],
      sodiumContent: data['sodiumContent'],
      sugarContent: data['sugarContent'],
    );
  }

  Nutrition copyWith({
    String? calories,
    String? fatContent,
    String? proteinContent,
    String? carbohydrateContent,
    String? fiberContent,
    String? sodiumContent,
    String? sugarContent,
  }) {
    return Nutrition(
      calories: calories ?? this.proteinContent,
      fatContent: fatContent ?? this.fatContent,
      proteinContent: proteinContent ?? this.proteinContent,
      carbohydrateContent: carbohydrateContent ?? this.carbohydrateContent,
      fiberContent: fiberContent ?? this.fiberContent,
      sodiumContent: sodiumContent ?? this.sodiumContent,
      sugarContent: sugarContent ?? this.sugarContent,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (this.calories != null) json['calories'] = this.calories;
    if (this.fatContent != null) json['fatContent'] = this.fatContent;
    if (this.proteinContent != null)
      json['proteinContent'] = this.proteinContent;
    if (this.carbohydrateContent != null)
      json['carbohydrateContent'] = this.carbohydrateContent;
    if (this.fiberContent != null) json['fiberContent'] = this.fiberContent;
    if (this.sodiumContent != null) json['sodiumContent'] = this.sodiumContent;
    if (this.sugarContent != null) json['sugarContent'] = this.sugarContent;
    return json;
  }

  @override
  List<Object?> get props => [
        calories,
        fatContent,
        proteinContent,
        carbohydrateContent,
        fiberContent,
        sodiumContent,
        sugarContent,
      ];
}
