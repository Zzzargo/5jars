class UserModel {
  final String id;
  final String username;
  final DateTime? createdAt;

  UserModel({required this.id, required this.username, this.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
