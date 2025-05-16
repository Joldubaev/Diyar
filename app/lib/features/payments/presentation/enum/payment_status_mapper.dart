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
    PaymentStatusEnum.otpError: "Ошибка OTP-кода.",
    PaymentStatusEnum.limitExceeded: "Превышен лимит транзакций.",
    PaymentStatusEnum.internalError: "Внутренняя ошибка сервера.",
    PaymentStatusEnum.failed: "Платёж не прошёл.",
    PaymentStatusEnum.unknown: "Неизвестная ошибка.",
    PaymentStatusEnum.alreadyExists: "Платёж уже существует.",
  };

  static PaymentStatusEnum fromCode(String code) {
    return codeToStatus[code] ?? PaymentStatusEnum.unknown;
  }

  static String message(PaymentStatusEnum status, [String? serverMessage]) {
    return statusToMessage[status] ?? (serverMessage ?? "Неизвестная ошибка.");
  }
}
