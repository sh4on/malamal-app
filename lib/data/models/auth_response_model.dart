/// user profile data details model
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? dob;
  final String? profilePhoto;
  // user access and authorization role
  final String? role;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.dob,
    this.profilePhoto,
    this.role,
  });

  /// map json to user profile instance
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      dob: json['dob'],
      profilePhoto: json['profilePhoto'] ?? json['image'],
      role: json['role'],
    );
  }

  /// map user profile instance to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'profilePhoto': profilePhoto,
      'role': role,
    };
  }
}

/// authentication response payload containing tokens and profile
class AuthResponseModel {
  final String accessToken;
  final String? refreshToken;
  final UserProfile user;

  const AuthResponseModel({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  /// map json to auth response model instance
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'],
      user: UserProfile.fromJson(json['user'] ?? {}),
    );
  }

  /// map auth response instance to json
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}
