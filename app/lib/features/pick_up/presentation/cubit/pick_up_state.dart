part of 'pick_up_cubit.dart';

@immutable
sealed class PickUpState {}

// Начальное состояние, может быть заменено на PickUpFormState() по умолчанию в кубите
final class PickUpInitial extends PickUpState {}

// Перечисление для отслеживания статуса работы с формой
enum FormSubmissionStatus {
  initial, // Начальное состояние формы, до взаимодействия
  validating, // В процессе валидации (если валидация асинхронная или сложная)
  inProgress, // Форма валидна, данные отправляются (не путать с CreatePickUpOrderLoading, который про сам запрос к серверу)
  success, // Общий успех операции, связанной с формой (например, данные из профиля загружены)
  failure, // Ошибка валидации формы или другая общая ошибка формы
}

// Перечисление для полей формы, чтобы типизировать ошибки валидации
enum PickUpFormField {
  userName,
  phone,
  time,
  comment, // Можно добавить другие поля, если они валидируются
}

// Состояние, представляющее данные и статус формы самовывоза
class PickUpFormState extends PickUpState {
  final String userName;
  final String phone;
  final String time;
  final String comment;
  final FormSubmissionStatus formStatus;
  final Map<PickUpFormField, String?> validationErrors; // Ошибки для каждого поля {field: errorMessage}
  final bool isProfileDataLoaded; // Флаг, что начальные данные (имя, телефон) из профиля загружены

  PickUpFormState({
    this.userName = '',
    this.phone = '+996', // Начальное значение по умолчанию для телефона
    this.time = '',
    this.comment = '',
    this.formStatus = FormSubmissionStatus.initial,
    this.validationErrors = const {},
    this.isProfileDataLoaded = false,
  });

  PickUpFormState copyWith({
    String? userName,
    String? phone,
    String? time,
    String? comment,
    FormSubmissionStatus? formStatus,
    Map<PickUpFormField, String?>? validationErrors,
    bool? isProfileDataLoaded,
    bool? clearTimeError, // Флаг для явной очистки ошибки времени
    bool? clearUserNameError,
    bool? clearPhoneError,
  }) {
    final newErrors = Map<PickUpFormField, String?>.from(validationErrors ?? this.validationErrors);
    if (clearTimeError == true) newErrors.remove(PickUpFormField.time);
    if (clearUserNameError == true) newErrors.remove(PickUpFormField.userName);
    if (clearPhoneError == true) newErrors.remove(PickUpFormField.phone);

    return PickUpFormState(
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      time: time ?? this.time,
      comment: comment ?? this.comment,
      formStatus: formStatus ?? this.formStatus,
      validationErrors: newErrors,
      isProfileDataLoaded: isProfileDataLoaded ?? this.isProfileDataLoaded,
    );
  }

  // Для удобства можно добавить геттеры
  bool get isFormValid => validationErrors.isEmpty && formStatus != FormSubmissionStatus.failure;
}

// Состояния для процесса непосредственного создания заказа на сервере
final class CreatePickUpOrderLoading extends PickUpState {}

final class CreatePickUpOrderLoaded extends PickUpState {
  // Можно добавить данные, если после создания заказа нужно что-то вернуть,
  // например, ID заказа или подтверждение.
  // final String orderId;
  // CreatePickUpOrderLoaded({required this.orderId});
}

final class CreatePickUpOrderError extends PickUpState {
  final String message;
  CreatePickUpOrderError(this.message);
}
