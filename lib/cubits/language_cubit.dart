import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguageState extends Equatable {
  final String locale;
  final TextDirection textDirection;
  final bool isArabic;

  const LanguageState({
    required this.locale,
    required this.textDirection,
    required this.isArabic,
  });

  @override
  List<Object> get props => [locale, textDirection, isArabic];
}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit()
      : super(const LanguageState(
          locale: 'en',
          textDirection: TextDirection.ltr,
          isArabic: false,
        )) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final isArabic = prefs.getBool('isArabic') ?? false;
    emit(LanguageState(
      locale: isArabic ? 'ar' : 'en',
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      isArabic: isArabic,
    ));
  }

  Future<void> toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final newIsArabic = !state.isArabic;
    await prefs.setBool('isArabic', newIsArabic);
    emit(LanguageState(
      locale: newIsArabic ? 'ar' : 'en',
      textDirection: newIsArabic ? TextDirection.rtl : TextDirection.ltr,
      isArabic: newIsArabic,
    ));
  }

  Future<void> setLanguage(bool isArabic) async {
    if (state.isArabic == isArabic) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isArabic', isArabic);
    emit(LanguageState(
      locale: isArabic ? 'ar' : 'en',
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      isArabic: isArabic,
    ));
  }
}
