import 'package:five_jars_ultra/features/transactions/models/transaction_type.dart';

class TransactionsFilters {
  final String? jarId;
  final TransactionType? type;
  final String? sortBy;
  final bool descending;

  const TransactionsFilters({
    this.jarId,
    this.type,
    // Defaults
    this.sortBy = 'createdAt',
    this.descending = true,
  });

  // A private sentinel that means "explicitly set to null"
  // Needed to allow null filters when using copyWith
  static const _unset = _Sentinel();

  TransactionsFilters copyWith({
    Object? jarId = _unset,
    Object? type = _unset,
    String? sortBy,
    bool? descending,
  }) {
    return TransactionsFilters(
      jarId: identical(jarId, _unset) ? this.jarId : jarId as String?,
      type: identical(type, _unset) ? this.type : type as TransactionType?,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
    );
  }

  // Convert to Query Parameters for the Client
  Map<String, dynamic> toMap() => {
    if (jarId != null) 'jarId': jarId,
    if (type != null) 'type': type!.apiValue,
    'sort': '$sortBy,${descending ? 'desc' : 'asc'}',
  };
}

class _Sentinel {
  const _Sentinel();
}
