import 'package:dolfin_flutter/data/models/child_model.dart';
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
          return MaterialPageRoute(builder: (_) => const ChildInfoPage());
        }
      case addchildpage:
        {
          final child = settings.arguments as ChildModel?;
          return MaterialPageRoute(
              builder: (_) => AddChildPage(
                    child: child,
                  ));
        }
      default:
        throw 'No Page Found!!';
    }
  }
}
