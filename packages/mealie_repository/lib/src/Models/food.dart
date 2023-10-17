part of '../mealie_repository.dart';

class Food extends Equatable {
  Food({
    required this.name,
    this.description,
    this.extras,
    this.labelId,
    required this.id,
    this.label,
    this.createdAt,
    this.updateAt,
  });
  final String name;
  final String? description;
  final Object? extras;
  final String? labelId;
  final String id;
  final Label? label;
  final String? createdAt;
  final String? updateAt;

  static Food? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Food(
      name: data['name'],
      description: data['description'],
      extras: data['extras'],
      labelId: data['labelId'],
      id: data['id'],
      label: Label.fromData(data: data['label']),
      createdAt: data['createdAt'],
      updateAt: data['updateAt'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = this.name;
    if (this.description != null) json['description'] = this.description;
    if (this.extras != null) json['extras'] = this.extras;
    if (this.labelId != null) json['labelId'] = this.labelId;
    json['id'] = this.id;
    if (this.label != null) json['label'] = this.label!.toJson();
    if (this.createdAt != null) json['createdAt'] = this.createdAt;
    if (this.updateAt != null) json['updateAt'] = this.updateAt;
    return json;
  }

  @override
  List<Object?> get props => [
        name,
        description,
        extras,
        labelId,
        id,
        label,
        createdAt,
        updateAt,
      ];
}
