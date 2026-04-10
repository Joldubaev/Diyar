/// Exception thrown when there is an error related to caching.
class CacheException implements Exception {}

/// Exception thrown when there is an error related to the server.
class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  ServerException(this.message, this.statusCode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is ServerException) {
      return other.message == message && other.statusCode == statusCode;
    }
    return false;
  }

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;
}

/// Exception thrown when API call is cancelled.
class CancelTokenException implements Exception {
  final String message;
  final int? statusCode;

  CancelTokenException(this.message, this.statusCode);
}

class OfflineException implements Exception {}

class WeekPassException implements Exception {}

class ExistedAccountException implements Exception {}

class NoUserException implements Exception {}

class WrongPasswordException implements Exception {}

class TooManyRequestsException implements Exception {}
