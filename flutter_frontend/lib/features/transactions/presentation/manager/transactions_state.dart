import 'package:five_jars_ultra/features/transactions/models/transaction_model.dart';
import 'package:five_jars_ultra/features/transactions/models/transactions_filters.dart';

sealed class TransactionsState {}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoadSuccess extends TransactionsState {
  final List<TransactionModel> transactions;
  final TransactionsFilters filters;
  final int currentPage;
  final bool hasReachedMax;
  final bool isFetchingMore; // To show a little spinner while loading

  TransactionsLoadSuccess({
    required this.transactions,
    required this.filters,
    required this.currentPage,
    required this.hasReachedMax,
    this.isFetchingMore = false,
  });

  // Helper for immutability
  TransactionsLoadSuccess copyWith({
    List<TransactionModel>? transactions,
    TransactionsFilters? filters,
    int? currentPage,
    bool? hasReachedMax,
    bool? isFetchingMore,
  }) {
    return TransactionsLoadSuccess(
      transactions: transactions ?? this.transactions,
      filters: filters ?? this.filters,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}

class TransactionsLoadFailure extends TransactionsState {
  final String message;
  TransactionsLoadFailure(this.message);
}
