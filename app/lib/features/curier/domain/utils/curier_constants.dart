class CurierConstants {
  const CurierConstants._();

  static const int historyPageSize = 10;
  static const double scrollLoadThreshold = 0.8;
  static const locationUpdateInterval = Duration(seconds: 2);

  /// Статус заказа, при котором курьер должен забрать его из ресторана.
  static const String statusCooked = 'Cooked';
}
