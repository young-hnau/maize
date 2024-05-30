part of '../mealie_repository.dart';

class ShoppingListItem extends Equatable {
  const ShoppingListItem({
    required this.shoppingListId,
    required this.checked,
    this.position,
    this.isFood,
    required this.note,
    required this.quantity,
    this.foodId,
    this.labelId,
    this.unitId,
    this.extras,
    this.id,
    this.display,
    this.food,
    this.label,
    this.unit,
    this.recipeReferences,
    this.createdAt,
    this.updateAt,
  });

  final String shoppingListId;
  final bool checked;
  final int? position;
  final bool? isFood;
  final String note;
  final double quantity;
  final String? foodId;
  final String? labelId;
  final String? unitId;
  final Object? extras;
  final String? id;
  final String? display;
  final Food? food;
  final Label? label;
  final Unit? unit;
  final List<RecipeReference?>? recipeReferences;
  final String? createdAt;
  final String? updateAt;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    json['shoppingListId'] = this.shoppingListId;
    json['checked'] = this.checked;
    if (this.position != null) json['position'] = this.position;
    if (this.isFood != null) json['isFood'] = this.isFood;
    json['note'] = this.note;
    json['quantity'] = this.quantity;
    if (this.foodId != null) json['foodId'] = this.foodId;
    if (this.labelId != null) json['labelId'] = this.labelId;
    if (this.unitId != null) json['unitId'] = this.unitId;
    if (this.extras != null) json['extras'] = this.extras;
    if (this.recipeReferences != null && recipeReferences!.length > 0)
      json['recipeReferences'] =
          List.generate(recipeReferences!.length, (int index) {
        RecipeReference? recipeReference = recipeReferences![index];
        if (recipeReference != null) {
          return recipeReference.toJson();
        }
      });
    return json;
  }

  ShoppingListItem copyWith({
    bool? checked,
    int? position,
    bool? isFood,
    String? note,
    double? quantity,
    String? foodId,
    String? labelId,
    String? unitId,
    Object? extras,
    String? display,
    Food? food,
    Label? label,
    Unit? unit,
    List<RecipeReference?>? recipeReferences,
    String? createdAt,
    String? updateAt,
  }) {
    return ShoppingListItem(
      shoppingListId: shoppingListId,
      checked: checked ?? this.checked,
      position: position ?? this.position,
      isFood: isFood ?? this.isFood,
      note: note ?? this.note,
      quantity: quantity ?? this.quantity,
      foodId: foodId ?? this.foodId,
      labelId: labelId ?? this.labelId,
      unitId: unitId ?? this.unitId,
      extras: extras ?? this.extras,
      id: id,
      display: display ?? this.display,
      food: food ?? this.food,
      label: label ?? this.label,
      unit: unit ?? this.unit,
      recipeReferences: recipeReferences ?? this.recipeReferences,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  static ShoppingListItem? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return ShoppingListItem(
      shoppingListId: data['shoppingListId'],
      checked: data['checked'],
      position: data['position'],
      isFood: data['isFood'],
      note: data['note'],
      quantity: data['quantity'],
      foodId: data['foodId'],
      labelId: data['labelId'],
      unitId: data['unitId'],
      extras: data['extras'],
      id: data['id'],
      display: data['display'],
      food: Food.fromData(data: data['food']),
      label: Label.fromData(data: data['label']),
      unit: Unit.fromData(data: data['unit']),
      recipeReferences: List<RecipeReference?>.generate(
          data['recipeReferences'].length,
          (int index) =>
              RecipeReference.fromData(data: data['recipeReferences'][index])),
      createdAt: data['createdAt'],
      updateAt: data['updateAt'],
    );
  }

  static final empty = ShoppingListItem(
    quantity: 0,
    note: '',
    display: '',
    checked: false,
    id: '',
    shoppingListId: '',
  );

  @override
  List<Object?> get props => [
        this.shoppingListId,
        this.checked,
        this.position,
        this.isFood,
        this.note,
        this.quantity,
        this.foodId,
        this.labelId,
        this.unitId,
        this.extras,
        this.id,
        this.display,
        this.food,
        this.label,
        this.unit,
        this.recipeReferences,
        this.createdAt,
        this.updateAt,
      ];
}

class ShoppingList extends Equatable {
  const ShoppingList({
    this.name,
    this.extras,
    this.createdAt,
    this.updateAt,
    required this.groupId,
    required this.id,
    required this.userId,
    this.items,
    required this.recipeReferences,
    required this.labelSettings,
  });

  final String? name;
  final Object? extras;
  final String? createdAt;
  final String? updateAt;
  final String groupId;
  final String id;
  final String userId;
  final List<ShoppingListItem>? items;
  final List<RecipeReference> recipeReferences;
  final List<LabelSetting> labelSettings;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (this.name != null) json['name'] = this.name;
    if (this.extras != null) json['extras'] = this.extras;
    if (this.createdAt != null) json['createdAt'] = this.createdAt;
    if (this.updateAt != null) json['updateAt'] = this.updateAt;
    json['groupId'] = this.groupId;
    json['id'] = this.id;
    json['userId'] = this.userId;
    json['items'] =
        items?.map((ShoppingListItem item) => item.toJson()).toList();
    return json;
  }

  ShoppingList copyWith({
    String? name,
    Object? extras,
    String? updateAt,
    List<ShoppingListItem>? items,
    List<RecipeReference>? recipeReferences,
    List<LabelSetting>? labelSettings,
  }) {
    return ShoppingList(
      name: name ?? this.name,
      extras: extras ?? this.extras,
      createdAt: createdAt,
      updateAt: updateAt ?? this.updateAt,
      groupId: groupId,
      id: id,
      userId: userId,
      items: items ?? this.items,
      recipeReferences: recipeReferences ?? this.recipeReferences,
      labelSettings: labelSettings ?? this.labelSettings,
    );
  }

  static ShoppingList fromdata({required Map<String, dynamic> data}) {
    List<ShoppingListItem>? items = List<ShoppingListItem>.from(data['items']
            ?.map((dynamic item) => ShoppingListItem.fromData(data: item)) ??
        const []);

    if (items.isEmpty) {
      items = List<ShoppingListItem>.from(data['listItems']
              ?.map((dynamic item) => ShoppingListItem.fromData(data: item)) ??
          []);
    }

    List<RecipeReference> recipeReferences = List<RecipeReference>.from(
        data['recipeReferences']?.map((dynamic recipeReference) =>
                RecipeReference.fromData(data: recipeReference)) ??
            const []);

    List<LabelSetting> labelSettings = List<LabelSetting>.from(
        data['labelSettings']?.map((dynamic labelSetting) =>
                LabelSetting.fromData(data: labelSetting)) ??
            const []);

    return ShoppingList(
      name: data['name'],
      extras: data['extras'],
      createdAt: data['createdAt'],
      updateAt: data['updateAt'],
      groupId: data['groupId'],
      userId: data['userId'],
      id: data['id'],
      items: items,
      recipeReferences: recipeReferences,
      labelSettings: labelSettings,
    );
  }

  static final empty = ShoppingList(
    name: '',
    groupId: '',
    id: '',
    userId: '',
    recipeReferences: const [],
    labelSettings: const [],
  );

  @override
  List<Object?> get props => [
        this.name,
        this.extras,
        this.createdAt,
        this.updateAt,
        this.groupId,
        this.userId,
        this.id,
        this.items,
        this.recipeReferences,
        this.labelSettings,
      ];
}
