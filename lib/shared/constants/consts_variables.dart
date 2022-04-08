import 'package:flutter/material.dart';
import 'package:dolfin_flutter/data/models/onboarding_model.dart';
import 'package:dolfin_flutter/shared/constants/assets_path.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

List<OnBoardingModel> onboardinglist = const [
  OnBoardingModel(
    img: MyAssets.onboradingone,
    title: 'Get Reiminders',
    description:
        'Daily reminders to give your child supplements and submit their data.',
  ),
  OnBoardingModel(
    img: MyAssets.onboradingtwo,
    title: 'Submit Your Data',
    description: 'Upload all of your trial data directly from the app.',
  ),
  OnBoardingModel(
    img: MyAssets.onboradingthree,
    title: 'Track Your Data',
    description: "View your child's weight and dosage history.",
  ),
];

const List<Color> colors = [
  AppColours.blue,
  AppColours.green,
  AppColours.pink,
  AppColours.yellow
];
