sealed class RegisterEvent {}

final class RegisterSubmitted extends RegisterEvent {
  final String nickname;
  final String username;
  final String password;

  RegisterSubmitted({
    required this.nickname,
    required this.username,
    required this.password,
  });
}
