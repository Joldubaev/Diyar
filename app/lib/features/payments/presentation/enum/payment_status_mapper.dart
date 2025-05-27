import 'paymethod_enum.dart';

class PaymentStatusMapper {
  static final Map<String, PaymentStatusEnum> codeToStatus = {
    "200": PaymentStatusEnum.success,
    "120": PaymentStatusEnum.success,
    "110": PaymentStatusEnum.success,
    "132": PaymentStatusEnum.pending,
    "201": PaymentStatusEnum.pending,
    "104": PaymentStatusEnum.badRequest,
    "128": PaymentStatusEnum.insufficientFunds,
    "126": PaymentStatusEnum.userBlocked,
    "404": PaymentStatusEnum.notFound,
    "107": PaymentStatusEnum.accessDenied,
    "124": PaymentStatusEnum.otpError,
    "306": PaymentStatusEnum.limitExceeded,
    "105": PaymentStatusEnum.internalError,
    '112': PaymentStatusEnum.alreadyExists,
  };

  static final Map<PaymentStatusEnum, String> statusToMessage = {
    PaymentStatusEnum.success: "Платёж успешно завершён.",
    PaymentStatusEnum.pending: "Ожидание оплаты...",
    PaymentStatusEnum.badRequest: "Некорректный запрос.",
    PaymentStatusEnum.insufficientFunds: "Недостаточно средств.",
    PaymentStatusEnum.userBlocked: "Пользователь заблокирован.",
    PaymentStatusEnum.notFound: "Платёж или пользователь не найден.",
    PaymentStatusEnum.accessDenied: "Доступ запрещён.",
    PaymentStatusEnum.otpError: "Неверный OTP код",
    PaymentStatusEnum.limitExceeded: "Превышен лимит транзакций.",
    PaymentStatusEnum.internalError: "Внутренняя ошибка сервера.",
    PaymentStatusEnum.failed: "Платёж не прошёл.",
    PaymentStatusEnum.unknown: "Неизвестная ошибка.",
    PaymentStatusEnum.alreadyExists: "Платёж уже существует.",
  };

  /// Универсальный маппер: code, message, data
  static PaymentStatusEnum fromCode(dynamic code, {String? message, String? data}) {
    final codeStr = code?.toString() ?? '';
    final msg = message?.toLowerCase() ?? '';
    final dataStr = data?.toUpperCase() ?? '';
    if (codeStr == '100' || msg == 'success' || dataStr == 'SUCCESSFUL') {
      return PaymentStatusEnum.success;
    }
    if (codeStr == '101' || msg == 'pending') {
      return PaymentStatusEnum.pending;
    }
    if (codeStr == '102' || msg == 'failed') {
      return PaymentStatusEnum.failed;
    }
    return codeToStatus[codeStr] ?? PaymentStatusEnum.unknown;
  }

  static String message(PaymentStatusEnum status, [String? serverMessage]) {
    return statusToMessage[status] ?? (serverMessage ?? "Неизвестная ошибка.");
  }
}
