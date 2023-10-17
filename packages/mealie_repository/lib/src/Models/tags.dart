part of '../mealie_repository.dart';

class Tag extends Equatable {
  Tag({
    required this.id,
    required this.name,
    required this.slug,
  });

  final String id;
  final String name;
  final String slug;

  static Tag? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Tag(
      id: data['id'],
      name: data['name'],
      slug: data['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    json['name'] = this.name;
    json['slug'] = this.slug;
    return json;
  }

  @override
  List<Object?> get props => [id, name, slug];
}
