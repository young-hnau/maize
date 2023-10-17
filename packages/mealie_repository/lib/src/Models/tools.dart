part of '../mealie_repository.dart';

class Tool extends Equatable {
  Tool({
    required this.id,
    required this.name,
    required this.slug,
    required this.onHand,
  });

  final String id;
  final String name;
  final String slug;
  final bool onHand;

  static Tool? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Tool(
      id: data['id'],
      name: data['name'],
      slug: data['slug'],
      onHand: data['onHand'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    json['name'] = this.name;
    json['slug'] = this.slug;
    json['onHand'] = this.onHand;
    return json;
  }

  @override
  List<Object?> get props => [id, name, slug, onHand];
}
