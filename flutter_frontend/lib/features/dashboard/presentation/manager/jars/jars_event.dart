import 'package:five_jars_ultra/features/dashboard/dtos/create_jar_request.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/money_op_request.dart';

sealed class JarsEvent {}

class JarsFetchRequested extends JarsEvent {}

class NewJarRequested extends JarsEvent {
  final CreateJarRequest createRequest;

  NewJarRequested(this.createRequest);
}

class JarDepositRequested extends JarsEvent {
  final MoneyOpRequest request;
  final String jarId;

  JarDepositRequested(this.jarId, this.request);
}
