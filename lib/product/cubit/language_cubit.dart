import 'package:bootcamperciyes_final_project/product/constant/language_constant.dart';
import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:bootcamperciyes_final_project/product/service/database_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubitState with EquatableMixin {
  final Languages language;

  LanguageCubitState({
    required this.language,
  });

  LanguageCubitState copyWith({
    Languages? language,
  }) =>
      LanguageCubitState(
        language: language ?? this.language,
      );

  @override
  List<Object?> get props => [language];
}

class LanguageCubit extends Cubit<LanguageCubitState> {
  LanguageCubit() : super(LanguageCubitState(language: Application.language));

  Future<void> changeLanguage(Languages language) async {
    emit(state.copyWith(language: language));
    await DatabaseService.instance.database.put('language', language.name);
  }
}
