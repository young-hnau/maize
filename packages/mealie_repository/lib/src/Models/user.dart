part of '../mealie_repository.dart';

// ignore_for_file: slash_for_doc_comments

/// {@template User}
/// User model for handling all information related to the user
///
/// {@endtemplate}
class User extends Equatable {
  /***************************************
   * 
   * CONSTRUCTORS
   * 
   ***************************************/

  const User._({
    // required String token,
    required String refreshToken,
    String? username,
    String? fullName,
    String? email,
    String? group,
    String? id,
    String? groupId,
    String? cacheKey,
    bool? admin,
    // this.authenticated,
  })  :
        // _uri = uri,
        // _token = token,
        _refreshToken = refreshToken,
        _username = username,
        _fullName = fullName,
        _email = email,
        _group = group,
        _id = id,
        _groupId = groupId,
        _cacheKey = cacheKey,
        _admin = admin;

  factory User({
    // required String token,
    required String refreshToken,
    String? username,
    String? fullName,
    String? email,
    String? group,
    String? id,
    String? groupId,
    String? cacheKey,
    bool? admin,
  }) {
    // StreamController authenticated = StreamController<bool>();
    return User._(
      // token: token,
      refreshToken: refreshToken,
      username: username,
      fullName: fullName,
      email: email,
      group: group,
      id: id,
      groupId: groupId,
      cacheKey: cacheKey,
      admin: admin,
      // authenticated: authenticated,
    );
  }

  factory User.fromMealieResponse(
      {required Map<String, dynamic> data,
      String? token,
      required String refreshToken}) {
    // StreamController authenticated = StreamController<bool>();
    return User._(
      // token: token,
      refreshToken: refreshToken,
      username: data['username'],
      fullName: data['fullName'],
      email: data['email'],
      group: data['group'],
      id: data['id'],
      groupId: data['groupId'],
      cacheKey: data['cacheKey'],
      admin: data['admin'],
      // authenticated: authenticated,
    );
  }

  User copyWith({
    String? token,
    String? refreshToken,
    String? username,
    String? fullName,
    String? email,
    String? group,
    String? id,
    String? groupId,
    String? cacheKey,
    bool? admin,
  }) {
    return User._(
      // uri: _uri,
      // token: token ?? _token,
      refreshToken: refreshToken ?? _refreshToken,
      username: username ?? _username,
      fullName: fullName ?? _fullName,
      email: email ?? _email,
      group: group ?? _group,
      id: id ?? _id,
      groupId: groupId ?? _groupId,
      cacheKey: cacheKey ?? _cacheKey,
      admin: admin ?? _admin,
      // authenticated: authenticated,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    json['username'] = this.username;
    json['admin'] = this.admin;
    return json;
  }

  /***************************************
   * 
   * PRIVATE VARIABLES
   * 
   ***************************************/
  // final String _token;
  final String _refreshToken;
  final String? _username;
  final String? _fullName;
  final String? _email;
  final String? _group;
  final String? _id;
  final String? _groupId;
  final String? _cacheKey;
  final bool? _admin;

  // final StreamController? authenticated;

  /***************************************
   * 
   * PUBLIC VARIABLES
   * 
   ***************************************/

  static const empty = User._(refreshToken: '');

  /***************************************
   * 
   * GETTERS
   * 
   ***************************************/

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  String? get username => _username;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get group => _group;
  String? get id => _id;
  String? get groupId => _groupId;
  String? get cacheKey => _cacheKey;
  bool? get admin => _admin;

  String get refreshToken => _refreshToken;

  // Future<String?> get token async {
  //   String? token = (await MealieRepository(uri: Uri.parse(_uri))
  //           .getRefreshToken(token: _token))
  //       .refreshToken;

  //   if (token == null) {
  //     authenticated?.add(false);
  //   }

  //   return token;
  // }

  /***************************************
   * 
   * SETTERS - NULL IF @IMMUTABLE
   * 
   ***************************************/

  /***************************************
   * 
   * FUNCTIONS
   * 
   ***************************************/

  /***************************************
   * 
   * OVERRIDES
   * 
   ***************************************/
  @override
  List<Object?> get props => [
        // _token,
        _refreshToken,
        _username,
        _fullName,
        _email,
        _group,
        _id,
        _groupId,
        _cacheKey,
        _admin,
      ];
}
