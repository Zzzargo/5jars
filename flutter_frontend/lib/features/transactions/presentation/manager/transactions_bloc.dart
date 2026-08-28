import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/core/config/notification_service.dart';
import 'package:five_jars_ultra/features/transactions/data/transactions_client.dart';
import 'package:five_jars_ultra/features/transactions/models/transactions_filters.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_event.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionsClient _client;
  static const int _pageSize = 20;
  static const _fetchMoreDebounceDuration = Duration(milliseconds: 300);

  final NotificationService notificationService =
      serviceLocator<NotificationService>();

  TransactionsBloc(this._client) : super(TransactionsInitial()) {
    // First fetch
    on<TransactionsFetchRequested>((event, emit) async {
      final TransactionsFilters filters = switch (state) {
        TransactionsLoadSuccess(:final filters) => filters,
        TransactionsLoading(:final filters) => filters,
        _ => const TransactionsFilters(),
      };

      emit(
        TransactionsLoading(filters),
      ); // Keep the filters in the loading state to avoid losing them

      final result = await _client.getAllTransactions(
        page: 0,
        filters: filters,
      );

      switch (result) {
        case ResourceSuccess s:
          emit(
            TransactionsLoadSuccess(
              transactions: s.data,
              filters: filters,
              currentPage: 0,
              hasReachedMax: s.data.length < _pageSize,
            ),
          );
        case ResourceError e:
          emit(TransactionsLoadFailure(e.message));
      }
    });

    on<TransactionsFilterChanged>((event, emit) async {
      emit(TransactionsLoading(event.filters));

      final result = await _client.getAllTransactions(
        page: 0,
        filters: event.filters,
      );

      switch (result) {
        case ResourceSuccess s:
          emit(
            TransactionsLoadSuccess(
              transactions: s.data,
              filters: event.filters,
              currentPage: 0,
              hasReachedMax: s.data.length < _pageSize,
            ),
          );
        case ResourceError e:
          emit(TransactionsLoadFailure(e.message));
      }
    });

    // `Load more` fetches
    on<MoreTransactionsRequested>(
      _onLoadMore,
      transformer: (events, mapper) {
        return droppable<MoreTransactionsRequested>().call(
          events.throttleTime(_fetchMoreDebounceDuration),
          mapper,
        );
      },
    );

    on<TransactionsResetRequested>((event, emit) {
      emit(TransactionsInitial());
    });
  }

  Future<void> _onLoadMore(
    MoreTransactionsRequested event,
    Emitter<TransactionsState> emit,
  ) async {
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
      filters: currentState.filters,
    );

    switch (result) {
      case ResourceSuccess s:
        emit(
          TransactionsLoadSuccess(
            transactions: List.from(currentState.transactions)..addAll(s.data),
            filters: currentState.filters,
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
  }

  void reset() {
    add(TransactionsResetRequested());
  }
}
