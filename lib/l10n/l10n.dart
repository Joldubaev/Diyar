import 'package:flutter/widgets.dart';
import 'package:diyar/l10n/generated/app_localizations.dart';
export 'package:diyar/l10n/generated/app_localizations.dart';


extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
