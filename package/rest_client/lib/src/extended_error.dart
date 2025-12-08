/// [ExtendedError] - это "запечатанный" (sealed) базовый класс
/// для специфичных внутренних ошибок приложения. Использование `sealed`
/// гарантирует, что все наследники определены в этом же файле, что
/// позволяет компилятору проверять полноту обработки ошибок в switch-выражениях.
/// Эти ошибки обычно перехватываются и преобразуются в [AppFailure].
sealed class ExtendedError {
  const ExtendedError();
}

/// [NoConnectionError] представляет ошибку, возникающую при попытке
/// выполнить сетевой запрос без активного интернет-соединения.
class NoConnectionError extends ExtendedError {
  const NoConnectionError();
}

/// [ParseError] представляет ошибку, которая возникает в процессе
/// парсинга (преобразования) данных, например, из JSON в модель Dart.
class ParseError extends ExtendedError {
  const ParseError();
}
