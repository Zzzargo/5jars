import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/core/config/notification_service.dart';
import 'package:five_jars_ultra/features/transactions/data/transactions_client.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_event.dart';
import 'package:five_jars_ultra/features/transactions/presentation/manager/transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionsClient _client;
  final NotificationService notificationService =
      serviceLocator<NotificationService>();

  TransactionsBloc(this._client) : super(TransactionsInitial()) {
    on<TransactionsFetchRequested>((event, emit) async {
      emit(TransactionsLoading());
      final result = await _client.getAllTransactions();

      switch (result) {
        case ResourceSuccess s:
          emit(TransactionsLoadSuccess(s.data));
        case ResourceError e:
          emit(TransactionsLoadFailure(e.message));
      }
    });
  }
}
