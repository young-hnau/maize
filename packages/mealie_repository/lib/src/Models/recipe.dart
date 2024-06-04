part of '../mealie_repository.dart';

class RecipeReference extends Equatable {
  RecipeReference({
    required this.id,
    this.shoppingListItemId,
    required this.recipeId,
    required this.recipeQuantity,
    this.recipeScale,
    this.recipeNote,
    this.recipe,
  });

  final String id;
  final String? shoppingListItemId;
  final String recipeId;
  final double recipeQuantity;
  final double? recipeScale;
  final String? recipeNote;
  final Recipe? recipe;

  static RecipeReference? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return RecipeReference(
        id: data['id'],
        shoppingListItemId: data['shoppingListItemId'],
        recipeId: data['recipeId'],
        recipeQuantity: data['recipeQuantity'],
        recipeScale: data['recipeScale'],
        recipeNote: data['recipeNote'],
        recipe: Recipe.fromData(data: data['recipe']));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    if (this.shoppingListItemId != null)
      json['shoppingListItemId'] = this.shoppingListItemId;
    json['recipeId'] = this.recipeId;
    json['recipeQuantity'] = this.recipeQuantity;
    if (this.recipeScale != null) json['recipeScale'] = this.recipeScale;
    if (this.recipeNote != null) json['recipeNote'] = this.recipeNote;
    if (this.recipe != null) json['recipe'] = this.recipe!.toJson();
    return json;
  }

  @override
  List<Object?> get props => [
        id,
        shoppingListItemId,
        recipeId,
        recipeQuantity,
        recipeScale,
        recipeNote,
        recipe,
      ];
}

class Recipe extends Equatable {
  const Recipe({
    required this.id,
    this.userId,
    required this.groupId,
    this.name,
    this.slug,
    this.image,
    this.imagePath,
    this.recipeYield,
    this.totalTime,
    this.prepTime,
    this.cookTime,
    this.performTime,
    this.description,
    this.recipeCategory,
    this.tags,
    this.tools,
    this.rating,
    this.orgURL,
    this.dateAdded,
    this.dateUpdated,
    this.createdAt,
    this.updateAt,
    this.lastMade,
    this.recipeIngredient,
    this.recipeInstructions,
    this.nutrition,
    this.settings,
    this.assets,
    this.notes,
    this.extras,
    this.isOcrRecipe,
    this.comments,
  });

  final String id;
  final String? userId;
  final String groupId;
  final String? name;
  final String? slug;
  final String? image;
  final String? imagePath;
  final String? recipeYield;
  final String? totalTime;
  final String? prepTime;
  final String? cookTime;
  final String? performTime;
  final String? description;
  final List<RecipeCategory>? recipeCategory;
  final List<Tag>? tags;
  final List<Tool>? tools;
  final double? rating;
  final String? orgURL;
  final String? dateAdded;
  final String? dateUpdated;
  final String? createdAt;
  final String? updateAt;
  final String? lastMade;
  final List<Ingredient>? recipeIngredient;
  final List<Instruction>? recipeInstructions;
  final Nutrition? nutrition;
  final Settings? settings;
  final List<Asset>? assets;
  final List<Note>? notes;
  final Object? extras;
  final bool? isOcrRecipe;
  final List<Comment>? comments;

  static Recipe? fromData({required Map<String, dynamic>? data}) {
    if (data == null) return null;
    final List<RecipeCategory> recipeCategory = List<RecipeCategory>.from(
        data['recipeCategory']?.map((dynamic category) =>
                RecipeCategory.fromData(data: category)) ??
            const []);

    final List<Tag>? tags = data['tags'] == null
        ? null
        : List<Tag>.from(
            data['tags'].map((dynamic tag) => Tag.fromData(data: tag)) ??
                const []);

    final List<Tool>? tools = data['tools'] == null
        ? null
        : List<Tool>.from(
            data['tools'].map((dynamic tool) => Tool.fromData(data: tool)) ??
                const []);

    String? image = data['image'];
    try {
      if (!Uri.parse(image ?? "").isAbsolute) throw FormatException();
    } on FormatException {
      image = null;
    }

    String imagePath = '/api/media/recipes/${data['id']}/images/original.webp';

    List<Ingredient> recipeIngredients = [];
    if (data['recipeIngredient'] != null) {
      for (dynamic ingredient in data['recipeIngredient']) {
        recipeIngredients.add(Ingredient.fromData(data: ingredient));
      }
    }

    List<Instruction> recipeInstructions = [];
    if (data['recipeInstructions'] != null) {
      for (dynamic ingredient in data['recipeInstructions']) {
        recipeInstructions.add(Instruction.fromData(data: ingredient));
      }
    }

    final List<Asset>? assets = data['assets'] == null
        ? null
        : List<Asset>.from(data['assets']
                .map((dynamic asset) => Asset.fromData(data: asset)) ??
            const []);

    final List<Note>? notes = data['notes'] == null
        ? null
        : List<Note>.from(
            data['notes'].map((dynamic note) => Note.fromData(data: note)) ??
                const []);

    final List<Comment>? comments = data['comments'] == null
        ? null
        : List<Comment>.from(data['comments']
                .map((dynamic comment) => Comment.fromData(data: comment)) ??
            const []);

    return Recipe(
      id: data['id'],
      userId: data['userId'],
      groupId: data['groupId'],
      name: data['name'],
      slug: data['slug'],
      image: image,
      imagePath: imagePath,
      recipeYield: data['recipeYield'],
      totalTime: data['totalTime'],
      prepTime: data['prepTime'],
      cookTime: data['cookTime'],
      performTime: data['performTime'],
      description: data['description'],
      recipeCategory: recipeCategory,
      tags: tags,
      tools: tools,
      rating: data['rating'],
      orgURL: data['orgURL'],
      dateAdded: data['dateAdded'],
      dateUpdated: data['dateUpdated'],
      createdAt: data['createdAt'],
      updateAt: data['updateAt'],
      lastMade: data['lastMade'],
      recipeIngredient: recipeIngredients,
      recipeInstructions: recipeInstructions,
      nutrition: Nutrition.fromData(data: data['nutrition']),
      settings: Settings.fromData(data: data['settings']),
      assets: assets,
      notes: notes,
      extras: data['extras'],
      isOcrRecipe: data['isOcrRecipe'],
      comments: comments,
    );
  }

  factory Recipe.from(Recipe? recipe) {
    if (recipe == null) return Recipe.empty;
    return new Recipe(
      id: recipe.id,
      userId: recipe.userId,
      groupId: recipe.groupId,
      name: recipe.name,
      slug: recipe.slug,
      image: recipe.image,
      imagePath: recipe.imagePath,
      recipeYield: recipe.recipeYield,
      totalTime: recipe.totalTime,
      prepTime: recipe.prepTime,
      cookTime: recipe.cookTime,
      performTime: recipe.performTime,
      description: recipe.description,
      recipeCategory: recipe.recipeCategory == null
          ? null
          : List<RecipeCategory>.from(recipe.recipeCategory!),
      tags: recipe.tags == null ? null : List<Tag>.from(recipe.tags!),
      tools: recipe.tools == null ? null : List<Tool>.from(recipe.tools!),
      rating: recipe.rating,
      orgURL: recipe.orgURL,
      dateAdded: recipe.dateAdded,
      dateUpdated: recipe.dateUpdated,
      createdAt: recipe.createdAt,
      updateAt: recipe.updateAt,
      lastMade: recipe.lastMade,
      recipeIngredient: recipe.recipeIngredient == null
          ? null
          : List<Ingredient>.from(recipe.recipeIngredient!),
      recipeInstructions: recipe.recipeInstructions == null
          ? null
          : List<Instruction>.from(recipe.recipeInstructions!),
      nutrition: recipe.nutrition,
      settings: recipe.settings,
      assets: recipe.assets == null ? null : List<Asset>.from(recipe.assets!),
      notes: recipe.notes == null ? null : List<Note>.from(recipe.notes!),
      extras: recipe.extras,
      isOcrRecipe: recipe.isOcrRecipe,
      comments:
          recipe.comments == null ? null : List<Comment>.from(recipe.comments!),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    if (this.userId != null) json['userId'] = this.userId;
    json['groupId'] = this.groupId;
    if (this.name != null) json['name'] = this.name;
    if (this.slug != null) json['slug'] = this.slug;
    if (this.image != null) json['image'] = this.image;
    if (this.imagePath != null) json['imagePath'] = this.imagePath;
    if (this.recipeYield != null) json['recipeYield'] = this.recipeYield;
    if (this.totalTime != null) json['totalTime'] = this.totalTime;
    if (this.prepTime != null) json['prepTime'] = this.prepTime;
    if (this.cookTime != null) json['cookTime'] = this.cookTime;
    if (this.performTime != null) json['performTime'] = this.performTime;
    if (this.description != null) json['description'] = this.description;
    if (this.recipeCategory != null)
      json['recipeCategory'] = this
          .recipeCategory!
          .map((RecipeCategory recipeCategory) => recipeCategory.toJson())
          .toList();
    if (this.tags != null)
      json['tags'] = this.tags!.map((Tag tag) => tag.toJson()).toList();
    if (this.tools != null)
      json['tools'] = this.tools!.map((Tool tool) => tool.toJson()).toList();
    if (this.rating != null) json['rating'] = this.rating;
    if (this.orgURL != null) json['orgURL'] = this.orgURL;
    if (this.dateAdded != null) json['dateAdded'] = this.dateAdded;
    if (this.dateUpdated != null) json['dateUpdated'] = this.dateUpdated;
    if (this.createdAt != null) json['createdAt'] = this.createdAt;
    if (this.updateAt != null) json['updateAt'] = this.updateAt;
    if (this.lastMade != null) json['lastMade'] = this.lastMade;
    if (this.recipeIngredient != null)
      json['recipeIngredient'] = this
          .recipeIngredient!
          .map((Ingredient ingredient) => ingredient.toJson())
          .toList();
    if (this.recipeInstructions != null)
      json['recipeInstructions'] = this
          .recipeInstructions!
          .map((Instruction instruction) => instruction.toJson())
          .toList();
    if (this.nutrition != null) json['nutrition'] = this.nutrition!.toJson();
    if (this.settings != null) json['settings'] = this.settings!.toJson();
    if (this.assets != null)
      json['assets'] =
          this.assets!.map((Asset asset) => asset.toJson()).toList();
    if (this.notes != null)
      json['notes'] = this.notes!.map((Note note) => note.toJson()).toList();
    if (this.extras != null) json['extras'] = this.extras;
    if (this.isOcrRecipe != null) json['isOcrRecipe'] = this.isOcrRecipe;
    if (this.comments != null)
      json['comments'] =
          this.comments!.map((Comment comment) => comment.toJson()).toList();
    return json;
  }

  Recipe copyWith({
    String? userId,
    String? name,
    String? slug,
    String? image,
    String? imagePath,
    String? recipeYield,
    String? totalTime,
    String? prepTime,
    String? cookTime,
    String? performTime,
    String? description,
    List<RecipeCategory>? recipeCategory,
    List<Tag>? tags,
    List<Tool>? tools,
    double? rating,
    String? orgURL,
    String? dateAdded,
    String? dateUpdated,
    String? createdAt,
    String? updateAt,
    String? lastMade,
    List<Ingredient>? recipeIngredients,
    List<Instruction>? recipeInstructions,
    Nutrition? nutrition,
    Settings? settings,
    List<Asset>? assets,
    List<Note>? notes,
    Object? extras,
    bool? isOcrRecipe,
    List<Comment>? comments,
  }) {
    return new Recipe(
      id: id,
      userId: userId ?? this.userId,
      groupId: groupId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      image: image ?? this.image,
      imagePath: imagePath ?? this.imagePath,
      recipeYield: recipeYield ?? this.recipeYield,
      totalTime: totalTime ?? this.totalTime,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      performTime: performTime ?? this.performTime,
      description: description ?? this.description,
      recipeCategory: recipeCategory ?? this.recipeCategory,
      tags: tags ?? this.tags,
      tools: tools ?? this.tools,
      rating: rating ?? this.rating,
      orgURL: orgURL ?? this.orgURL,
      dateAdded: dateAdded ?? this.dateAdded,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
      lastMade: lastMade ?? this.lastMade,
      recipeIngredient: recipeIngredients ?? this.recipeIngredient,
      recipeInstructions: recipeInstructions ?? this.recipeInstructions,
      nutrition: nutrition ?? this.nutrition,
      settings: settings ?? this.settings,
      assets: assets ?? this.assets,
      notes: notes ?? this.notes,
      extras: extras ?? this.extras,
      isOcrRecipe: isOcrRecipe ?? this.isOcrRecipe,
      comments: comments ?? this.comments,
    );
  }

  static const empty = Recipe(id: '', groupId: '');

  @override
  List<Object?> get props => [
        this.id,
        this.userId,
        this.groupId,
        this.name,
        this.slug,
        this.image,
        this.imagePath,
        this.recipeYield,
        this.totalTime,
        this.prepTime,
        this.cookTime,
        this.performTime,
        this.description,
        this.recipeCategory,
        this.tags,
        this.tools,
        this.rating,
        this.orgURL,
        this.dateAdded,
        this.dateUpdated,
        this.createdAt,
        this.updateAt,
        this.lastMade,
        this.recipeIngredient,
        this.recipeInstructions,
        this.nutrition,
        this.settings,
        this.assets,
        this.notes,
        this.extras,
        this.isOcrRecipe,
        this.comments,
      ];
}

class RecipeCategory extends Equatable {
  RecipeCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  final String id;
  final String name;
  final String slug;

  static RecipeCategory? fromData({Map<String, dynamic>? data}) {
    if (data == null) return null;
    return RecipeCategory(
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
