sealed class TransactionsEvent {}

class TransactionsFetchRequested extends TransactionsEvent {}

class MoreTransactionsRequested extends TransactionsEvent {}

class TransactionsResetRequested extends TransactionsEvent {}
