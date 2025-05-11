import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotted/config/locale/supported_localisations.dart';

final languagesListProvider = Provider((ref) => localeInfos);

final localeProvider =
    StateNotifierProvider<LanguageNotifier, LocaleInfos?>((ref) {
  String? userLanguage = localeInfos.first.localeCode;
  final languageNotifier = LanguageNotifier();
  final localeInfo = localeInfos.firstWhere(
    (l) => l.localeCode == userLanguage,
    orElse: () => LocaleInfos.empty(),
  );
  if (localeInfo.localeCode != LocaleInfos.empty().localeCode) {
    languageNotifier.changeSelectedLanguage(localeInfo);
  }
  return languageNotifier;
});

class LanguageNotifier extends StateNotifier<LocaleInfos?> {
  LanguageNotifier() : super(LocaleInfos.empty());

  void changeSelectedLanguage(LocaleInfos newLocaleInfo) {
    state = state?.copyWith(
        name: newLocaleInfo.name,
        flag: newLocaleInfo.flag,
        localeCode: newLocaleInfo.localeCode);
  }
}