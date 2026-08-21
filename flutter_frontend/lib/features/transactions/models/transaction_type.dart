enum TransactionType {
  incomeDistribution('INCOME_DISTRIBUTION'),
  deposit('DEPOSIT'),
  withdrawal('WITHDRAWAL'),
  transfer('TRANSFER');

  const TransactionType(this.apiValue);

  final String apiValue;

  // Human readable names
  String get displayName {
    final raw = apiValue.replaceAll('_', ' ').toLowerCase();
    if (raw.isEmpty) return "";
    return raw[0].toUpperCase() + raw.substring(1);
  }

  static TransactionType fromApi(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => throw ArgumentError('Unknown transaction type: $value'),
    );
  }
}
