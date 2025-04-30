import '../../../injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(Brightness.light)) {
    emit(
      ThemeState(
        sl<SharedPreferences>().getBool('isDark') == true
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  void toggleTheme(Brightness brightness) {
    sl<SharedPreferences>().setBool('isDark', brightness == Brightness.dark);
    emit(ThemeState(brightness));
  }
}
