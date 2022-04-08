import 'package:flutter/material.dart';
import 'package:dolfin_flutter/data/models/onboarding_model.dart';
import 'package:dolfin_flutter/shared/constants/assets_path.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

List<OnBoardingModel> onboardinglist = const [
  OnBoardingModel(
    img: MyAssets.onboradingone,
    title: 'Manage Your Task',
    description:
        'With This Small App You Can Orgnize All Your Tasks and Duties In A One Single App.',
  ),
  OnBoardingModel(
    img: MyAssets.onboradingtwo,
    title: 'Plan Your Day',
    description: 'Add A Task And The App Will Remind You.',
  ),
  OnBoardingModel(
    img: MyAssets.onboradingthree,
    title: 'Accomplish Your Goals ',
    description: 'Track Your Activities And Accomplish Your Goals.',
  ),
];

const List<Color> colors = [
  AppColours.blue,
  AppColours.green,
  AppColours.pink,
  AppColours.yellow
];
