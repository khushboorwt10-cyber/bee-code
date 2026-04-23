library;


class LoginRequest {
  final String email;
  final String password;
  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
class SignUpRequest {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName, // ✅ MUST be this
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      };
}

class GoogleLoginRequest {
  final String idToken;
  const GoogleLoginRequest({required this.idToken});

  Map<String, dynamic> toJson() => {'id_token': idToken};
}


class AuthResponse {
  final String token;
  final UserData user;

  const AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json['token'] as String? ?? json['access_token'] as String? ?? '',
        user: UserData.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      );
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? json['full_name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        photoUrl: json['photo_url'] as String? ?? json['avatar'] as String?,
      );
}