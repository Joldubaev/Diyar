/// Internal errors thrown during request processing.
/// Caught by [NetworkErrorHandler] and converted to [AppFailure].
sealed class ExtendedError {
  const ExtendedError();
}

/// No active internet connection.
class NoConnectionError extends ExtendedError {
  const NoConnectionError();
}

/// Failed to parse response data.
class ParseError extends ExtendedError {
  const ParseError();
}
