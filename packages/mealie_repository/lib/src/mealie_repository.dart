import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'Models/shopping_lists.dart';
part 'Models/recipe.dart';
part 'Models/labels.dart';
part 'Models/food.dart';
part 'Models/unit.dart';
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
  });

  final Uri uri;
  final Dio dio = Dio();
  final StreamController authenticated = StreamController<bool>();
  final StreamController refreshToken = StreamController<String>.broadcast();
  final StreamController errorStream = StreamController<String>.broadcast();
  final User? user;

  MealieRepository copyWith({User? user, Uri? uri}) {
    return MealieRepository(
      uri: uri ?? this.uri,
      user: user ?? this.user,
    );
  }

  Future<bool> uriIsValid({bool save = false}) async {
    final Uri uri = this.uri.replace(path: "/api/app/about");
    try {
      final Response response = await dio.getUri(uri);
      if (response.statusCode == 200) {
        if (save) {
          final SharedPreferences p = await SharedPreferences.getInstance();
          p.setString("__self_hosted_uri__", uri.toString());
        }
        return true;
      } else {
        return false;
      }
    } on DioException {
      return false;
    } on SocketException {
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
        this.refreshToken.add(refreshToken);
      } on DioException {
        // Both refresh token and access token have expired
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
          data: response.data, refreshToken: refreshToken!);
    } on DioException catch (err) {
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
      }
    }

    return user;
  }

  Future<List<ShoppingList>?> getAllShoppingLists(
      {required String token}) async {
    final String? refreshToken = await _getRefreshToken(token: token);

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
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
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
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
      }
    }

    return shoppingList;
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
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
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
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
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
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
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
        recipes.add(Recipe.fromData(data: item));
      }
    } on DioException catch (err) {
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
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
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
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
      if (err.response != null) {
        this.errorStream.add(err.response?.data['detail'].toString());
      } else {
        this.errorStream.add(err.message.toString());
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
}

enum ImageType {
  orginial,
  min_original,
  tiny_original,
}
