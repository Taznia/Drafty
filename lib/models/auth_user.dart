class AuthUser {
  const AuthUser({required this.id, required this.name, required this.email, this.profilePhotoUrl});

  final String id;
  final String name;
  final String email;
  final String? profilePhotoUrl;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
      );
}

class AuthSession {
  const AuthSession({required this.user, required this.accessToken});

  final AuthUser user;
  final String accessToken;
}
