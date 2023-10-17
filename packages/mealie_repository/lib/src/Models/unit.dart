part of '../mealie_repository.dart';

class Unit extends Equatable {
  Unit({
    required this.name,
    this.description,
    this.extras,
    this.fraction,
    this.abbreviation,
    this.useAbbreviation,
    required this.id,
    this.createdAt,
    this.updateAt,
  });
  final String name;
  final String? description;
  final Object? extras;
  final double? fraction;
  final String? abbreviation;
  final bool? useAbbreviation;
  final String id;
  final String? createdAt;
  final String? updateAt;

  static Unit? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Unit(
      name: data['name'],
      description: data['description'],
      extras: data['extras'],
      fraction: data['fraction'],
      abbreviation: data['abbreviation'],
      useAbbreviation: data['useAbbreviation'],
      id: data['id'],
      createdAt: data['createdAt'],
      updateAt: data['updateAt'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = this.name;
    if (this.description != null) json['description'] = this.description;
    if (this.extras != null) json['extras'] = this.extras;
    if (this.fraction != null) json['fraction'] = this.fraction;
    if (this.abbreviation != null) json['abbreviation'] = this.abbreviation;
    if (this.useAbbreviation != null)
      json['useAbbreviation'] = this.useAbbreviation;
    json['id'] = this.id;
    if (this.createdAt != null) json['createdAt'] = this.createdAt;
    if (this.updateAt != null) json['updateAt'] = this.updateAt;
    return json;
  }

  @override
  List<Object?> get props => [
        name,
        description,
        extras,
        fraction,
        abbreviation,
        useAbbreviation,
        id,
        createdAt,
        updateAt,
      ];
}
