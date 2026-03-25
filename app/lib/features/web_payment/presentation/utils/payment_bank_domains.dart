/// Домены банков для App Links / Universal Links.
/// Только известные домены пробуем открыть во внешнем приложении.
class PaymentBankDomains {
  PaymentBankDomains._();

  static const Set<String> known = {
    // Киргизия
    'bakai.kg',
    'dengi.o.kg',
    'o.kg',
    'megapay.kg',
    'dengi.kg',
    'namba.kg',
    'mbank.kg',
    'balance.kg',
    'kicb.kg',
    'demirbank.kg',
    'kompanion.kg',
  };

  static bool isKnown(String? host) {
    if (host == null) return false;
    final h = host.toLowerCase();
    for (final domain in known) {
      if (h == domain || h.endsWith('.$domain')) return true;
    }
    return false;
  }
}
