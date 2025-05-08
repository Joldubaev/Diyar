import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:diyar/core/components/models/food_item_order_entity.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/pick_up/pick_up.dart';
import 'package:diyar/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:meta/meta.dart';

part 'pick_up_state.dart';

class PickUpCubit extends Cubit<PickUpState> {
  final PickUpRepositories _pickUpRepository;
  final ProfileCubit _profileCubit;
  StreamSubscription? _profileSubscription;

  PickUpCubit(this._pickUpRepository, this._profileCubit) : super(PickUpFormState()) {
    _listenToProfileUpdates();
    final initialProfileState = _profileCubit.state;
    if (initialProfileState is ProfileGetLoaded) {
      _initializeFormData(initialProfileState.userModel);
    } else {
      _profileCubit.getUser();
    }
  }

  void _listenToProfileUpdates() {
    _profileSubscription = _profileCubit.stream.listen((profileState) {
      if (profileState is ProfileGetLoaded) {
        final currentFormState = state;
        if (currentFormState is PickUpFormState &&
            (!currentFormState.isProfileDataLoaded ||
                currentFormState.userName.isEmpty ||
                (currentFormState.phone.isEmpty || currentFormState.phone == '+996'))) {
          _initializeFormData(profileState.userModel);
        }
      }
    });
  }

  void _initializeFormData(UserModel user) {
    if (state is PickUpFormState) {
      final currentFormState = state as PickUpFormState;
      emit(currentFormState.copyWith(
        userName: currentFormState.userName.isEmpty ? user.userName ?? '' : currentFormState.userName,
        phone: (currentFormState.phone.isEmpty || currentFormState.phone == '+996') && (user.phone.isNotEmpty)
            ? user.phone
            : currentFormState.phone,
        isProfileDataLoaded: true,
      ));
    }
  }

  void userNameChanged(String value) {
    if (state is PickUpFormState) {
      final currentFormState = state as PickUpFormState;
      emit(currentFormState.copyWith(
          userName: value, clearUserNameError: true, formStatus: FormSubmissionStatus.initial));
    }
  }

  void phoneChanged(String value) {
    if (state is PickUpFormState) {
      final currentFormState = state as PickUpFormState;
      emit(currentFormState.copyWith(phone: value, clearPhoneError: true, formStatus: FormSubmissionStatus.initial));
    }
  }

  void timeChanged(String value) {
    if (state is PickUpFormState) {
      final currentFormState = state as PickUpFormState;
      emit(currentFormState.copyWith(time: value, clearTimeError: true, formStatus: FormSubmissionStatus.initial));
    }
  }

  void commentChanged(String value) {
    if (state is PickUpFormState) {
      final currentFormState = state as PickUpFormState;
      emit(currentFormState.copyWith(comment: value, formStatus: FormSubmissionStatus.initial));
    }
  }

  bool _validateFormAndUpdateState() {
    if (state is! PickUpFormState) return false;
    final formState = state as PickUpFormState;
    final errors = <PickUpFormField, String?>{};

    if (formState.userName.isEmpty) {
      errors[PickUpFormField.userName] = "Пожалуйста, введите ваше имя";
    } else if (formState.userName.length < 2) {
      errors[PickUpFormField.userName] = "Имя должно содержать хотя бы 2 символа";
    }

    final unmaskedPhone = formState.phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (formState.phone == '+996' || unmaskedPhone.length < 12) {
      errors[PickUpFormField.phone] = "Введите полный номер телефона";
    }

    if (formState.time.isEmpty) {
      errors[PickUpFormField.time] = "Пожалуйста, выберите время";
    } else {
      final timeParts = formState.time.split(':');
      if (timeParts.length != 2) {
        errors[PickUpFormField.time] = "Неверный формат времени";
      } else {
        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1]);
        if (hour == null || minute == null) {
          errors[PickUpFormField.time] = "Неверный формат времени (часы/минуты)";
        } else if ((hour >= 23) || (hour < 10)) {
          errors[PickUpFormField.time] = "Время работы с 10:00 до 22:59";
        }
      }
    }

    emit(formState.copyWith(
        validationErrors: errors,
        formStatus: errors.isEmpty ? FormSubmissionStatus.initial : FormSubmissionStatus.failure));
    return errors.isEmpty;
  }

  Future<void> submitPickupOrder({
    required List<CartItemEntity> cart,
    required int totalPriceFromWidget,
    required int dishesCount,
  }) async {
    if (state is! PickUpFormState) return;
    final formState = state as PickUpFormState;

    if (!_validateFormAndUpdateState()) return;

    emit(CreatePickUpOrderLoading());

    final List<FoodItemOrderEntity> foodEntities = cart
        .map((cartItem) {
          final foodEntityFromCart = cartItem.food;
          if (foodEntityFromCart == null) return null;
          final String? dishId = foodEntityFromCart.id;
          final String? name = foodEntityFromCart.name;
          final int? price = foodEntityFromCart.price;
          final int quantity = cartItem.quantity ?? 1;
          if (dishId == null || name == null || price == null) return null;
          return FoodItemOrderEntity(dishId: dishId, name: name, price: price, quantity: quantity);
        })
        .whereType<FoodItemOrderEntity>()
        .toList();

    if (foodEntities.isEmpty && cart.isNotEmpty) {
      emit(CreatePickUpOrderError("Ошибка обработки товаров в корзине"));
      emit(formState.copyWith(formStatus: FormSubmissionStatus.failure));
      return;
    }

    final orderEntity = PickupOrderEntity(
      userName: formState.userName,
      userPhone: formState.phone,
      prepareFor: formState.time,
      comment: formState.comment,
      price: totalPriceFromWidget,
      dishesCount: dishesCount,
      foods: foodEntities,
    );

    try {
      final result = await _pickUpRepository.getPickupOrder(orderEntity);
      result.fold((failure) => emit(CreatePickUpOrderError(failure.message)), (_) {
        emit(CreatePickUpOrderLoaded());
        emit(PickUpFormState(
          isProfileDataLoaded: formState.isProfileDataLoaded,
          userName: formState.isProfileDataLoaded ? formState.userName : '',
          phone: formState.isProfileDataLoaded ? formState.phone : '+996',
        ));
      });
    } catch (e) {
      emit(CreatePickUpOrderError(e.toString()));
      emit(formState.copyWith(formStatus: FormSubmissionStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
