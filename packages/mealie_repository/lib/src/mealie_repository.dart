import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'Models/shopping_lists.dart';
part 'Models/recipe.dart';
part 'Models/labels.dart';
part 'Models/favorites.dart';
part 'Models/food.dart';
part 'Models/unit.dart';
part 'Models/ratings.dart';
part 'Models/tags.dart';
part 'Models/tools.dart';
part 'Models/user.dart';
part 'Models/ingredient.dart';
part 'Models/instruction.dart';
part 'Models/nutrition.dart';
part 'Models/settings.dart';
part 'Models/asset.dart';
part 'Models/note.dart';
part 'Models/comment.dart';

class MealieRepository {
  MealieRepository({
    required this.uri,
    this.user,
    StreamController<bool>? authenticated,
    StreamController<String>? refreshToken,
    StreamController<String?>? errorStream,
  })  : authenticated = authenticated ?? StreamController<bool>(),
        refreshToken = refreshToken ?? StreamController<String>.broadcast(),
        errorStream = errorStream ?? StreamController<String?>.broadcast();

  final Uri uri;
  final Dio dio = Dio();
  final StreamController<bool> authenticated;
  final StreamController<String> refreshToken;
  final StreamController<String?> errorStream;
  final User? user;

  MealieRepository copyWith({User? user, Uri? uri}) {
    return MealieRepository(
      uri: uri ?? this.uri,
      user: user ?? this.user,
      authenticated: this.authenticated,
      refreshToken: this.refreshToken,
      errorStream: this.errorStream,
    );
  }

  /// Verifies that the current MealieRepository URI is valid
  /// and optionally saves it to device for future.
  ///
  /// Input:
  /// - save: will save URI to on device storage
  ///
  /// Returns:
  /// - bool: true if URI is a valid Mealie Instance uri
  Future<bool> uriIsValid({bool save = false}) async {
    final Uri uri = this.uri.replace(path: "/api/app/about");
    try {
      final Response response = await dio.getUri(uri,
          options: Options(sendTimeout: Duration(seconds: 20)));
      if (response.statusCode == 200) {
        if (save) {
          final SharedPreferences p = await SharedPreferences.getInstance();
          p.setString("__self_hosted_uri__", uri.toString());
        }
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (e.message != null) this.errorStream.add(e.message);
      return false;
    } on SocketException catch (e) {
      this.errorStream.add(e.message);
      return false;
    }
  }

  /// Logs in the user and optionally saves the Access Token to the device.
  /// Returns null if no access token can be obtained.
  ///
  /// Input:
  /// - username
  /// - password
  /// - save (optional)
  ///
  /// Return:
  /// - access token
  Future<String?> login({
    required String username,
    required String password,
    bool save = false,
  }) async {
    final data = FormData.fromMap({"username": username, "password": password});
    final Uri uri = this.uri.replace(path: '/api/auth/token');
    String? errorMessage = null;
    String? token;

    try {
      final Response response = await dio.postUri(uri, data: data);

      token = response.data['access_token'];

      if (save) {
        final SharedPreferences p = await SharedPreferences.getInstance();
        p.setString("__access_token__", token.toString());
      }
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        errorMessage = "Incorrect username or password.";
      } else if (err.response?.statusCode == 423) {
        errorMessage = "This account has been locked.";
      } else if (err.response?.statusCode == 522) {
        errorMessage = "Connection timed out.";
      } else if (err.response?.statusCode == 523) {
        errorMessage = "The host server is unreachable.";
      } else if (err.response?.statusCode == 502) {
        errorMessage = "There is a bad gateway to the host.";
      } else {
        errorMessage = err.message.toString();
      }

      this.errorStream.add(errorMessage);
    }

    return token;
  }

  /// Gets a refresh token with either the access token or another refresh token.
  /// If input token is invalid, attempts to read access token from device.
  /// Sinks 'false' to authenticated stream if neither provided or saved token is valid.
  /// Returns null if no refresh token can be obtained.
  ///
  /// Input:
  /// - token (access or refresh)
  ///
  /// Return:
  /// - refresh token
  Future<String?> _getRefreshToken({String? token}) async {
    final Uri uri = this.uri.replace(path: '/api/auth/refresh');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $token'});
    String? refreshToken;

    // // If we are not provided a token, attempt to read one from the device
    // if (token == null) {
    //   token = await _getTokenFromDevice();
    //   if (token == null) {
    //     this.authenticated.add(false);
    //   }
    // }

    try {
      if (token == null) {
        throw DioException(requestOptions: RequestOptions());
      }

      Response response = await dio.getUri(uri, options: options);
      refreshToken = response.data['access_token'];
      if (refreshToken == null) {
        throw Exception();
      }
      this.refreshToken.add(refreshToken);
    } on DioException {
      // Refresh token has expired, try the access token
      try {
        token = await _getTokenFromDevice();
        if (token == null) {
          throw DioException(requestOptions: RequestOptions());
        }

        final Options options =
            Options(headers: {'Authorization': 'Bearer $token'});

        Response response = await dio.getUri(uri, options: options);
        refreshToken = response.data['access_token'];
        if (refreshToken == null) {
          throw Exception();
        }
        this.refreshToken.add(refreshToken);
      } on DioException {
        // Both refresh token and access token have expired
        this.authenticated.add(false);
      } on Exception {
        this.authenticated.add(false);
      }
    }

    return refreshToken;
  }

  /// Attempts to read the Access Token from on device
  /// Returns null if none is found
  ///
  /// Return:
  /// - access token
  Future<String?> _getTokenFromDevice() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String? accessToken = p.getString("__access_token__");

    if (accessToken == null || accessToken == "null") {
      return null;
    }

    return accessToken;
  }

  /// Gets the user from Mealie.
  ///
  /// If no token is provided, an attempt will be made to get one from on device.
  /// If no valid token can be obtained, 'false' will be sunk into {authenticated} stream.
  ///
  /// Return:
  /// - user
  Future<User?> getUser({String? token}) async {
    final String? refreshToken = await _getRefreshToken(token: token);
    if (refreshToken == null) return null;

    final Uri uri = this.uri.replace(path: '/api/users/self');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $refreshToken'});
    User? user;

    try {
      final Response response = await dio.getUri(uri, options: options);
      user = User.fromMealieResponse(
          data: response.data, refreshToken: refreshToken);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }

    return user;
  }

  Future<List<ShoppingList>?> getAllShoppingLists() async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/groups/shopping/lists');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $refreshToken'});
    List<ShoppingList>? shoppingLists;

    try {
      final Response response = await dio.getUri(uri, options: options);
      shoppingLists = [];
      for (Map<String, dynamic> item in response.data['items']) {
        shoppingLists.add(ShoppingList.fromdata(data: item));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }

    return shoppingLists;
  }

  Future<ShoppingList?> getOneShoppingList({required ShoppingList list}) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri =
        this.uri.replace(path: '/api/groups/shopping/lists/${list.id}');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $refreshToken'});
    ShoppingList? shoppingList;

    try {
      final Response response = await dio.getUri(uri, options: options);
      shoppingList = ShoppingList.fromdata(data: response.data);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }

    return shoppingList;
  }

  Future<ShoppingList?> createOneShoppingList({required String name}) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/groups/shopping/lists');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $refreshToken'});
    ShoppingList? shoppingList;
    Map<String, dynamic> data = {
      'name': name,
    };

    try {
      final Response response =
          await dio.postUri(uri, options: options, data: data);
      shoppingList = ShoppingList.fromdata(data: response.data);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }

    return shoppingList;
  }

  Future<void> deleteOneShoppingList({required String id}) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/groups/shopping/lists/$id');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $refreshToken'});

    try {
      await dio.deleteUri(uri, options: options);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }

    return;
  }

  Future<void> updateOneShoppingListItem(
      {required ShoppingListItem item}) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri =
        this.uri.replace(path: '/api/groups/shopping/items/${item.id}');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $refreshToken'});

    try {
      final Map<String, dynamic> data = item.toJson();
      await dio.putUri(uri, options: options, data: data);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
  }

  Future<void> deleteOneShoppingListItem(
      {required ShoppingListItem item}) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri =
        this.uri.replace(path: '/api/groups/shopping/items/${item.id}');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $refreshToken'});

    try {
      await dio.deleteUri(uri, options: options);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
  }

  Future<void> createOneShoppingListItem(
      {required ShoppingListItem item}) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/groups/shopping/items');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    try {
      await dio.postUri(uri, options: options, data: item.toJson());
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
  }

  Future<void> addRecipeIngredientsToShoppingList({
    required Recipe recipe,
    required ShoppingList shoppingList,
    int? recipeIncrementQuantity,
  }) async {
    if (recipe.recipeIngredient == null) return;

    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(
        path:
            '/api/groups/shopping/lists/${shoppingList.id}/recipe/${recipe.id}');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );
    final Map<String, dynamic> data = {
      'recipeIncrementQuantity': recipeIncrementQuantity ?? 1,
      'recipeIngredients':
          recipe.recipeIngredient!.map((Ingredient i) => i.toJson()).toList()
    };

    try {
      await dio.postUri(uri, options: options, data: data);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
  }

  Future<List<Recipe>?> getAllRecipes({
    int? page,
    int? perPage,
    String? orderBy,
    String? orderDirection,
    String? queryFilter,
    bool? requireAllCategories,
    bool? requireAllTags,
    bool? requireAllFoods,
    String? search,
  }) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);
    List<Recipe>? recipes;

    final Map<String, dynamic> queryParameters = {};
    if (page != null) queryParameters['page'] = page.toString();
    if (perPage != null) queryParameters['perPage'] = perPage.toString();
    if (orderBy != null) queryParameters['orderBy'] = orderBy;
    if (orderDirection != null)
      queryParameters['orderDirection'] = orderDirection;
    if (queryFilter != null) queryParameters['queryFilter'] = queryFilter;
    if (requireAllCategories != null)
      queryParameters['requireAllCategories'] = requireAllCategories;
    if (requireAllTags != null)
      queryParameters['requireAllTags'] = requireAllTags;
    if (requireAllFoods != null)
      queryParameters['requireAllFoods'] = requireAllFoods;
    if (search != null) queryParameters['search'] = search;

    final Uri uri = this
        .uri
        .replace(path: '/api/recipes', queryParameters: queryParameters);
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    try {
      final Response response = await dio.getUri(uri, options: options);
      recipes = [];
      for (dynamic item in response.data['items']) {
        Recipe? recipe = Recipe.fromData(data: item);
        if (recipe != null) recipes.add(recipe);
      }
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }

    return recipes;
  }

  Future<Recipe?> getRecipe({
    required String slug,
  }) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);
    Recipe? recipe;

    final Uri uri = this.uri.replace(path: '/api/recipes/$slug');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    try {
      final Response response = await dio.getUri(uri, options: options);
      recipe = Recipe.fromData(data: response.data);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }

    return recipe;
  }

  Future<void> updateOneRecipe({required Recipe recipe}) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/recipes/${recipe.slug}');
    final Options options =
        Options(headers: {'Authorization': 'Bearer $refreshToken'});

    try {
      final Map<String, dynamic> data = recipe.toJson();
      await dio.putUri(uri, options: options, data: data);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
  }

  // Future<MealieResponse> getRecipeImage(
  //     {required String token,
  //     required Recipe recipe,
  //     ImageType imageType = ImageType.orginial}) async {
  //   MealieResponse responseData = MealieResponse(uri: this.uri);

  //   final String? refreshToken = (await getRefreshToken(token: token)).token;
  //   if (refreshToken == null) {
  //     authenticated.add(false);
  //   } else {
  //     this.refreshToken.add(refreshToken);
  //     token = refreshToken;
  //   }

  //   String imageTypeString;
  //   switch (imageType) {
  //     case ImageType.orginial:
  //       imageTypeString = "original.webp";
  //       break;
  //     case ImageType.min_original:
  //       imageTypeString = "min-original.webp";
  //       break;
  //     case ImageType.tiny_original:
  //       imageTypeString = "tiny-original.webp";
  //       break;
  //   }

  //   final Uri uri = this.uri.replace(
  //       path: '/api/media/recipes/${recipe.id}/image/${imageTypeString}');

  //   final Options options = Options(
  //     headers: {'Authorization': 'Bearer $token'},
  //     contentType: 'application/json',
  //   );

  //   try {
  //     final Response response = await dio.getUri(uri, options: options);
  //     responseData.data = response.data;
  //   } on DioException catch (err) {
  //     try {
  //       print(err.response?.data);
  //       Map<String, dynamic> data =
  //           Map<String, dynamic>.from(err.response?.data);
  //       responseData.errorMessage = data['detail'].toString();
  //     } on Exception {
  //       responseData.errorMessage = err.message.toString();
  //     }
  //   }

  //   return responseData;
  // }

  /// Takes in a URL and attempts to scrape data and load it into the database
  ///
  /// Return:
  /// - String? Recipe Slug
  Future<String?> parseRecipeURL(String url, bool includeTags) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/recipes/create-url');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );
    final Map<String, dynamic> data = {'includeTags': includeTags, 'url': url};

    try {
      Response response = await dio.postUri(uri, options: options, data: data);
      return response.data;
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return null;
  }

  /// Takes in a name and creates a new recipe entry in the database
  ///
  /// Return:
  /// - String? Recipe Slug
  Future<String?> createRecipe(String name) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/recipes');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );
    final Map<String, dynamic> data = {'name': name};

    try {
      Response response = await dio.postUri(uri, options: options, data: data);
      return response.data;
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return null;
  }

  /// Takes in a slug and deletes the specified recipe entry in the database
  Future<void> deleteRecipe(String slug) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/recipes/$slug');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    try {
      await dio.deleteUri(uri, options: options);
      return;
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return null;
  }

  /// Gets the logged in user's favorites
  ///
  /// This varies from getFavoriteRecipes by giving back only the recipe
  /// IDs and not the recipes themselves
  ///
  /// Return:
  /// - List<Favorites?>
  Future<List<Favorites?>> getFavorites() async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/users/${user?.id}/favorites');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    List<Favorites?> favorites = [];

    try {
      final Response response = await dio.getUri(uri, options: options);
      for (dynamic recipe in response.data['ratings'] ?? []) {
        favorites.add(Favorites.fromData(data: recipe));
      }
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return favorites;
  }

  /// Gets the logged in user's favorite recipes
  ///
  /// Return:
  /// - List<Recipe?>
  Future<List<Recipe?>> getFavoriteRecipes() async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/users/${user?.id}/favorites');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    List<Recipe?> recipes = [];

    try {
      final Response response = await dio.getUri(uri, options: options);
      for (dynamic favorite in response.data['ratings'] ?? []) {
        Recipe? recipe =
            await getRecipe(slug: Favorites.fromData(data: favorite)!.recipeId);
        recipes.add(recipe);
      }
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return recipes;
  }

  /// Adds the provided recipe to the user's favorite recipes
  ///
  /// Return:
  Future<void> addFavoriteRecipe(Recipe recipe) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this
        .uri
        .replace(path: '/api/users/${user?.id}/favorites/${recipe.slug}');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    try {
      await dio.postUri(uri, options: options);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return;
  }

  /// Removes the provided recipe from the user's favorite recipes
  ///
  /// Return:
  Future<void> removeFavoriteRecipe(Recipe recipe) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this
        .uri
        .replace(path: '/api/users/${user?.id}/favorites/${recipe.slug}');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    try {
      await dio.deleteUri(uri, options: options);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return;
  }

  /// Sets the recipe rating to the provided double
  ///
  /// Return:
  Future<void> setRecipeRating(
      {required Recipe recipe, required double rating}) async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri =
        this.uri.replace(path: '/api/users/${user?.id}/ratings/${recipe.slug}');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    final Map<String, dynamic> data = {"rating": rating};

    try {
      await dio.postUri(uri, options: options, data: data);
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return;
  }

  /// Gets all the ratings for all the recipes
  ///
  /// Return:
  /// - List<Rating>?
  Future<List<Rating>?> getRecipeRatings() async {
    final String? refreshToken =
        await _getRefreshToken(token: user?.refreshToken);

    final Uri uri = this.uri.replace(path: '/api/users/${user?.id}/ratings');
    final Options options = Options(
      headers: {'Authorization': 'Bearer $refreshToken'},
      contentType: 'application/json',
    );

    List<Rating> ratings = [];

    try {
      final Response response = await dio.getUri(uri, options: options);
      for (var rating in response.data['ratings']) {
        final Rating? r = Rating.fromData(data: rating);
        if (r == null) break;
        ratings.add(r);
      }
      return ratings;
    } on DioException catch (err) {
      if (err.response != null && err.response?.data['detail'] != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message);
      }
    }
    return null;
  }
}

enum ImageType {
  orginial,
  min_original,
  tiny_original,
}
