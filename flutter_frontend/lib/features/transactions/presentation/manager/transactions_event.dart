import 'package:five_jars_ultra/features/transactions/models/transactions_filters.dart';

sealed class TransactionsEvent {}

class TransactionsFetchRequested extends TransactionsEvent {}

class MoreTransactionsRequested extends TransactionsEvent {}

class TransactionsResetRequested extends TransactionsEvent {}

class TransactionsFilterChanged extends TransactionsEvent {
  final TransactionsFilters filters;
  TransactionsFilterChanged(this.filters);
}
