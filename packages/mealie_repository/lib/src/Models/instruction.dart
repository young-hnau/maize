part of '../mealie_repository.dart';

class Instruction extends Equatable {
  Instruction({
    this.id,
    this.title,
    this.text,
    this.recipeReferences,
  });

  final String? id;
  final String? title;
  final String? text;
  final List<String>? recipeReferences;

  static Instruction fromData({required Map<String, dynamic> data}) {
    List<String>? recipeReferences = data['recipeReferences'] != null
        ? List<String>.from(data['recipeReferences'])
        : null;
    return Instruction(
      id: data['id'],
      title: data['title'],
      text: data['text'],
      recipeReferences: recipeReferences,
    );
  }

  Instruction copyWith({
    String? title,
    String? text,
    List<String>? recipeReferences,
  }) {
    return Instruction(
      text: text ?? this.text,
      title: title ?? this.title,
      recipeReferences: recipeReferences ?? this.recipeReferences,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (this.id != null) json['id'] = this.id;
    if (this.title != null) json['title'] = this.title;
    if (this.text != null) json['text'] = this.text;
    if (this.recipeReferences != null)
      json['recipeReferences'] = this.recipeReferences;
    return json;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        text,
        recipeReferences,
      ];
}
