import 'package:app/models/user/user.dart';

class AuthApi {
  bool? isUser;
  User? user;
  String? accessToken;
  String? refreshToken;

  AuthApi({this.isUser, this.user, this.accessToken, this.refreshToken});

  AuthApi.fromJson(json) {
    isUser = json['is_user'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_user'] = isUser;
    if (user != null) map['user'] = user?.toJson();
    map['access_token'] = accessToken;
    map['refresh_token'] = refreshToken;
    return map;
  }
}
