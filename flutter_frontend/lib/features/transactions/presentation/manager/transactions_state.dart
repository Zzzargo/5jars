import 'package:five_jars_ultra/features/transactions/models/transaction_model.dart';

sealed class TransactionsState {}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoadSuccess extends TransactionsState {
  final List<TransactionModel> transactions;
  TransactionsLoadSuccess(this.transactions);
}

class TransactionsLoadFailure extends TransactionsState {
  final String message;
  TransactionsLoadFailure(this.message);
}
