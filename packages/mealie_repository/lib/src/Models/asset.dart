part of '../mealie_repository.dart';

class Asset extends Equatable {
  Asset({
    required this.name,
    required this.icon,
    this.fileName,
  });

  final String name;
  final String icon;
  final String? fileName;

  static Asset fromData({required Map<String, dynamic> data}) {
    return Asset(
        name: data['name'], icon: data['icon'], fileName: data['fileName']);
  }

  Asset copyWith({
    String? name,
    String? icon,
    String? fileName,
  }) {
    return Asset(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      fileName: fileName ?? this.fileName,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = this.name;
    json['icon'] = this.icon;
    json['fileName'] = this.fileName;
    return json;
  }

  @override
  List<Object?> get props => [name, icon, fileName];
}
