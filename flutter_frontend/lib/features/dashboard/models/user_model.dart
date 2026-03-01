class UserModel {
  final String id;
  final String username;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
