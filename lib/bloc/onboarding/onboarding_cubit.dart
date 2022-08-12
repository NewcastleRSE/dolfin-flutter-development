import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dolfin_flutter/shared/constants/consts_variables.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  int currentindex = 0;

  Future<void> savepref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  Future<bool?> getpref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool? pref = await prefs.getBool(key);
    return pref;
  }

  void skipIndex() {
    currentindex = onboardinglist.length - 1;

    emit(SkipIndexState());
  }

  void incrementIndex() {
    currentindex++;
    emit(ChangeCurrentIndexState());
  }

  void decrementIndex() {
    currentindex--;
    emit(RemoveFromCurrentIndexState());
  }
}
