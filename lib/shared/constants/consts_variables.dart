import 'package:flutter/material.dart';
import 'package:dolfin_flutter/data/models/onboarding_model.dart';
import 'package:dolfin_flutter/shared/constants/assets_path.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

List<OnBoardingModel> onboardinglist = const [
  OnBoardingModel(
    img: MyAssets.onboardingone,
    title: 'Get Reminders',
    description:
        "We'll remind you when it's time to submit your child's supplement data.",
  ),
  OnBoardingModel(
    img: MyAssets.onboardingtwo,
    title: 'Submit Your Data',
    description: 'Upload all of your trial data securely from the app.',
  ),
  OnBoardingModel(
    img: MyAssets.onboardingthree,
    title: 'Dosage History',
    description: "View your child's dosage history.",
  ),
  OnBoardingModel(
    img: MyAssets.onboardingfour,
    title: 'Other Features',
    description:
        "Use the app to track your child's weight and any unplanned hospital admissions.",
  ),
];

const List<Color> colors = [
  AppColours.blue,
  AppColours.green,
  AppColours.pink,
  AppColours.yellow
];
