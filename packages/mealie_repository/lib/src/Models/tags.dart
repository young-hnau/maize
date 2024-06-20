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

class TagResponse extends Equatable {
  TagResponse({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.items,
    required this.next,
    required this.previous,
  });

  final int? page;
  final int? perPage;
  final int? total;
  final int? totalPages;
  final List<Tag> items;
  final String? next;
  final String? previous;

  static TagResponse? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return TagResponse(
      page: data['page'],
      perPage: data['per_page'],
      total: data['total'],
      totalPages: data['total_pages'],
      items: List.generate(data['items'].toList().length,
          (index) => Tag.fromData(data: data['items'][index])!),
      next: data['next'],
      previous: data['previous'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (page != null) json['page'] = page;
    if (perPage != null) json['per_page'] = perPage;
    if (total != null) json['total'] = total;
    if (totalPages != null) json['total_pages'] = totalPages;
    json['items'] =
        List.generate(items.length, (index) => items[index].toJson());
    if (next != null) json['next'] = next;
    if (previous != null) json['previous'] = previous;

    return json;
  }

  @override
  List<Object?> get props => [
        page,
        perPage,
        total,
        totalPages,
        items,
        next,
        previous,
      ];
}
