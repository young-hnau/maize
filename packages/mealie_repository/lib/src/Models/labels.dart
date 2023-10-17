part of '../mealie_repository.dart';

class LabelSetting extends Equatable {
  LabelSetting({
    required this.shoppingListId,
    required this.labelId,
    required this.position,
    required this.id,
    required this.label,
  });
  final String shoppingListId;
  final String labelId;
  final int position;
  final String id;
  final Label label;

  static LabelSetting? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return LabelSetting(
      shoppingListId: data['shoppingListId'],
      labelId: data['labelId'],
      position: data['position'],
      id: data['id'],
      label: data['label'],
    );
  }

  @override
  List<Object?> get props => [
        shoppingListId,
        labelId,
        position,
        id,
        label,
      ];
}

class Label extends Equatable {
  Label({
    required this.name,
    required this.color,
    required this.groupId,
    required this.id,
  });

  final String name;
  final String color;
  final String groupId;
  final String id;

  static Label? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return Label(
      name: data['name'],
      color: data['color'],
      groupId: data['groupId'],
      id: data['id'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = this.name;
    json['color'] = this.color;
    json['groupId'] = this.groupId;
    json['id'] = this.id;
    return json;
  }

  @override
  List<Object?> get props => [
        name,
        color,
        groupId,
        id,
      ];
}
