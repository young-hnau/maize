part of '../mealie_repository.dart';

class Ingredient extends Equatable {
  Ingredient({
    this.quantity,
    this.unit,
    this.food,
    this.note,
    this.isFood,
    this.disableAmount,
    this.display,
    this.title,
    this.originalText,
    this.referenceId,
  });

  final double? quantity;
  final Unit? unit;
  final Food? food;
  final String? note;
  final bool? isFood;
  final bool? disableAmount;
  final String? display;
  final String? title;
  final String? originalText;
  final String? referenceId;

  static Ingredient fromData({required Map<String, dynamic> data}) {
    return Ingredient(
      quantity: data['quantity'],
      unit: Unit.fromData(data: data['unit']),
      food: Food.fromData(data: data['food']),
      note: data['note'],
      isFood: data['isFood'],
      disableAmount: data['disableAmount'],
      display: data['display'],
      title: data['title'],
      originalText: data['originalText'],
      referenceId: data['referenceId'],
    );
  }

  Ingredient copyWith({
    double? quantity,
    Unit? unit,
    Food? food,
    String? note,
    bool? isFood,
    bool? disableAmount,
    String? display,
    String? title,
    String? originalText,
    String? referenceId,
  }) {
    return Ingredient(
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      food: food ?? this.food,
      note: note ?? this.note,
      isFood: isFood ?? this.isFood,
      disableAmount: disableAmount ?? this.disableAmount,
      display: display ?? this.display,
      title: title ?? this.title,
      originalText: originalText ?? this.originalText,
      referenceId: referenceId ?? this.referenceId,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (this.quantity != null) json['quantity'] = this.quantity;
    if (this.unit != null) json['unit'] = this.unit!.toJson();
    if (this.food != null) json['food'] = this.food!.toJson();
    if (this.note != null) json['note'] = this.note;
    if (this.isFood != null) json['isFood'] = this.isFood;
    if (this.disableAmount != null) json['disableAmount'] = this.disableAmount;
    if (this.display != null) json['display'] = this.display;
    if (this.title != null) json['title'] = this.title;
    if (this.originalText != null) json['originalText'] = this.originalText;
    if (this.referenceId != null) json['referenceId'] = this.referenceId;
    return json;
  }

  @override
  List<Object?> get props => [
        this.quantity,
        this.unit,
        this.food,
        this.note,
        this.isFood,
        this.disableAmount,
        this.display,
        this.title,
        this.originalText,
        this.referenceId,
      ];
}
