import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/core/config/notification_service.dart';
import 'package:five_jars_ultra/features/transactions/data/transactions_client.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_event.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionsClient _client;
  static const int _pageSize = 20;

  final NotificationService notificationService =
      serviceLocator<NotificationService>();

  TransactionsBloc(this._client) : super(TransactionsInitial()) {
    // First fetch
    on<TransactionsFetchRequested>((event, emit) async {
      emit(TransactionsLoading());
      final result = await _client.getAllTransactions();

      switch (result) {
        case ResourceSuccess s:
          emit(
            TransactionsLoadSuccess(
              transactions: s.data,
              currentPage: 0,
              hasReachedMax: s.data.length < _pageSize,
            ),
          );
        case ResourceError e:
          emit(TransactionsLoadFailure(e.message));
      }
    });

    // `Load more` fetches
    on<MoreTransactionsRequested>((event, emit) async {
      final currentState = state;
      if (currentState is! TransactionsLoadSuccess ||
          currentState.hasReachedMax ||
          currentState.isFetchingMore) {
        return;
      }

      // Tell the UI we are fetching more
      emit(currentState.copyWith(isFetchingMore: true));

      final nextPage = currentState.currentPage + 1;
      final result = await _client.getAllTransactions(
        page: nextPage,
        pageSize: _pageSize,
      );

      switch (result) {
        case ResourceSuccess s:
          emit(
            TransactionsLoadSuccess(
              transactions: List.from(currentState.transactions)
                ..addAll(s.data),
              currentPage: nextPage,
              hasReachedMax: s.data.length < _pageSize,
              isFetchingMore: false,
            ),
          );
        case ResourceError _:
          emit(currentState.copyWith(isFetchingMore: false));
          serviceLocator<NotificationService>().showError(
            'Could not load more transactions',
          );
      }
    });

    on<TransactionsResetRequested>((event, emit) {
      emit(TransactionsInitial());
    });
  }

  void reset() {
    add(TransactionsResetRequested());
  }
}
