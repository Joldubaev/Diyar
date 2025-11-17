import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(const ThemeState(Brightness.light)) {
    emit(
      ThemeState(
        _prefs.getBool('isDark') == true
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  void toggleTheme(Brightness brightness) {
    _prefs.setBool('isDark', brightness == Brightness.dark);
    emit(ThemeState(brightness));
  }
}
