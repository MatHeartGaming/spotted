// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class LocaleInfos {
  final String name;
  final String flag;
  final String localeCode;

  LocaleInfos({
    required this.name,
    required this.flag,
    required this.localeCode,
  });

  LocaleInfos.empty({this.name = "", this.flag = "", this.localeCode = ""});

  LocaleInfos copyWith({
    String? name,
    String? flag,
    String? localeCode,
  }) {
    return LocaleInfos(
      name: name ?? this.name,
      flag: flag ?? this.flag,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  bool get isEmpty {
    return name.isEmpty || localeCode.isEmpty;
  }

  

  @override
  bool operator ==(covariant LocaleInfos other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.localeCode == localeCode;
  }

  @override
  int get hashCode => name.hashCode ^ localeCode.hashCode;
}

final List<LocaleInfos> localeInfos = [
  LocaleInfos(name: "Italiano", flag: "🇮🇹", localeCode: "it"),
];

final List<Locale> supportedLocalisations = [
  const Locale('it')
];

const Locale fallbackLocale = Locale('it');
