import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';

sealed class JarsState {}

class JarsInitial extends JarsState {}

class JarsLoading extends JarsState {}

class JarsLoadSuccess extends JarsState {
  final List<JarModel> jars;
  JarsLoadSuccess(this.jars);
}

class JarsLoadFailure extends JarsState {
  final String message;
  JarsLoadFailure(this.message);
}
