enum TransactionType {
  incomeDistribution('INCOME_DISTRIBUTION'),
  deposit('DEPOSIT'),
  withdrawal('WITHDRAWAL'),
  transfer('TRANSFER');

  const TransactionType(this.apiValue);

  final String apiValue;

  static TransactionType fromApi(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => throw ArgumentError('Unknown transaction type: $value'),
    );
  }
}
