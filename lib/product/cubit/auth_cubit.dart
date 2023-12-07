import 'dart:developer';

import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthCubitStatus { initial, loading, success, failure }

class AuthCubitState with EquatableMixin {
  final AuthCubitStatus status;
  final UserCredential? user;
  final String? error;

  AuthCubitState({
    this.status = AuthCubitStatus.initial,
    this.user,
    this.error,
  });

  AuthCubitState copyWith({
    AuthCubitStatus? status,
    UserCredential? user,
    String? error,
  }) =>
      AuthCubitState(
        status: status ?? this.status,
        user: user ?? this.user,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, user, error];
}

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit() : super(AuthCubitState());

  final google = GoogleSignIn.standard();

  Future<void> signIn() async {
    emit(state.copyWith(status: AuthCubitStatus.loading));
    try {
      GoogleSignInAccount? googleUser =
          await google.signInSilently(suppressErrors: true);
      googleUser ??= await google.signIn();

      final auth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken,
        idToken: auth?.idToken,
      );
      final firebaseUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint('Signed as ${firebaseUser.user?.displayName ?? 'unknown'}');

      inspect(googleUser);
      inspect(firebaseUser);
      emit(state.copyWith(status: AuthCubitStatus.success, user: firebaseUser));
    } catch (_) {
      inspect(_);
      emit(
        state.copyWith(
          status: AuthCubitStatus.failure,
          error: LocaleKeys.errors_something_went_wrong.tr(),
        ),
      );
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthCubitStatus.loading));
    await google.signOut();
    await FirebaseAuth.instance.signOut();

    debugPrint('Signed out');
    emit(AuthCubitState(status: AuthCubitStatus.success, user: null));
  }
}
