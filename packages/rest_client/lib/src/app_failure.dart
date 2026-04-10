import 'package:equatable/equatable.dart';
import 'package:rest_client/rest_client.dart';

/// [AppFailure] - это базовый абстрактный класс для всех типов ошибок (сбоев),
/// которые могут произойти в приложении. Он требует от всех наследников
/// реализации поля [message], которое содержит понятное для пользователя
/// или разработчика описание ошибки.
abstract interface class AppFailure {
  String get message;

  @override
  String toString() {
    return message;
  }
}

/// [UnknownFailure] представляет собой непредвиденную или необработанную ошибку,
/// которая не была явно отловлена. Она содержит исходный объект ошибки [failure]
/// и стек вызовов [stackTrace] для облегчения отладки.
class UnknownFailure extends Equatable implements AppFailure {
  const UnknownFailure({required this.failure, required this.stackTrace});

  final Object failure;
  final StackTrace stackTrace;

  @override
  String get message => "Unknown failure";

  @override
  String toString() {
    return "$message \n $failure $stackTrace";
  }

  @override
  List<Object?> get props => [message, failure, stackTrace];
}

/// [NetworkFailure] - это базовый класс для всех ошибок, связанных с сетью.
/// Он является "запечатанным" (sealed), что означает, что все его
/// подклассы должны быть определены в этом же файле. Это позволяет
/// обрабатывать сетевые ошибки исчерпывающим образом через switch-case.
sealed class NetworkFailure extends Equatable implements AppFailure {
  const NetworkFailure();

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return message;
  }
}

/// [NoInternetFailure] представляет ошибку, возникающую при отсутствии
/// интернет-соединения на устройстве.
class NoInternetFailure extends NetworkFailure {
  const NoInternetFailure();

  @override
  String get message => "Internet Fails";
}

/// [ServiceUnavailableFailure] представляет ошибку, когда сервер недоступен
/// или возвращает статусы, указывающие на временные сбои (например, 503).
class ServiceUnavailableFailure extends NetworkFailure {
  const ServiceUnavailableFailure({required this.statusCode});

  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String get message => "Service unavailable";
}

/// [ServerFailure] представляет ошибку, полученную от сервера (например,
/// статусы 4xx или 5xx), которая содержит тело ответа.
/// [ErrorJsonT] - это обобщенный тип (generic), который позволяет парсить
/// тело ошибки в определенную модель данных для более детальной обработки.
class ServerFailure<ErrorJsonT> extends NetworkFailure {
  const ServerFailure({
    required this.model,
    required this.statusCode,
    required this.json,
  });

  final ErrorJsonT model;
  final Map<String, dynamic> json;
  final int statusCode;

  @override
  String get message {
    // Если model — ServerErrorBody, возвращаем его message
    if (model is ServerErrorBody) {
      return (model as ServerErrorBody).message;
    }
    // Иначе стандартное сообщение
    return "Server error";
  }

  @override
  List<Object?> get props => [message, statusCode, model, json];

  @override
  String toString() => "$message \nmodel:\n${model.toString()}";
}
