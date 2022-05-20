import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:dolfin_flutter/presentation/screens/addrecord_page.dart';
import 'package:dolfin_flutter/presentation/screens/addweeklyrecord_page.dart';
import 'package:dolfin_flutter/presentation/screens/addweight_page.dart';
import 'package:dolfin_flutter/presentation/screens/childinfo_page.dart';
import 'package:flutter/material.dart';
import 'package:dolfin_flutter/presentation/screens/addchild_page.dart';
import 'package:dolfin_flutter/presentation/screens/login_page.dart';
import 'package:dolfin_flutter/presentation/screens/homepage.dart';
import 'package:dolfin_flutter/presentation/screens/onboarding.dart';
import 'package:dolfin_flutter/presentation/screens/signup_page.dart';
import 'package:dolfin_flutter/presentation/screens/welcome_page.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';

class AppRoute {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        {
          return MaterialPageRoute(builder: (_) => const OnboardingPage());
        }

      case welcomepage:
        {
          return MaterialPageRoute(builder: (_) => const WelcomePage());
        }

      case loginpage:
        {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      case signuppage:
        {
          return MaterialPageRoute(builder: (_) => const SignUpPage());
        }
      case homepage:
        {
          return MaterialPageRoute(builder: (_) => const HomePage());
        }
      case childinfopage:
        {
          final child = settings.arguments as ChildModel?;
          return MaterialPageRoute(
              builder: (_) => ChildInfoPage(
                    child: child,
                  ));
        }
      case addchildpage:
        {
          final child = settings.arguments as ChildModel?;
          return MaterialPageRoute(
              builder: (_) => AddChildPage(
                    child: child,
                  ));
        }
      case addweightpage:
        {
          final child = settings.arguments as ChildModel?;
          return MaterialPageRoute(
              builder: (_) => AddWeightPage(
                    child: child,
                  ));
        }
      case addweeklyrecordpage:
        {
          final child = settings.arguments as ChildModel?;
          return MaterialPageRoute(
              builder: (_) => AddWeeklyRecordPage(
                    child: child,
                  ));
        }
      case addrecordpage:
        {
          final arg = settings.arguments as Map<String, dynamic>;

          if (arg["data"] is ChildModel?) {
            return MaterialPageRoute(
                builder: (_) => AddRecordPage(
                      child: arg["data"] as ChildModel?,
                      date: arg["date"] as DateTime?,
                    ));
          } else {
            return MaterialPageRoute(
                builder: (_) => AddRecordPage(
                      record: arg["data"] as RecordModel?,
                      date: arg["date"] as DateTime?,
                    ));
          }
        }
      default:
        throw 'No Page Found!!';
    }
  }
}
