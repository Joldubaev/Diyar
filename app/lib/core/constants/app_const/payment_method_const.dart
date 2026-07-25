/// Значения `PaymentMethod`, которые принимает API заказов.
abstract class PaymentMethodApi {
  static const String cash = 'cash';
  static const String cardOnline = 'card_online';
  static const String cardCourier = 'card_courier';

  /// Заказ полностью покрыт бонусами — к оплате 0, онлайн-оплата не нужна.
  /// TODO(backend): уточнить, появится ли выделенное значение (например
  /// 'bonus'); пока шлём [cash], чтобы заказ не зависал в «ожидает оплаты».
  static const String fullyByBonus = cash;
}
