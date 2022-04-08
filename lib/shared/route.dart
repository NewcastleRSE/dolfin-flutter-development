import 'package:flutter/material.dart';
import 'package:dolfin_flutter/data/models/task_model.dart';
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
      case addchildpage:
        {
          final task = settings.arguments as TaskModel?;
          return MaterialPageRoute(
              builder: (_) => AddChildPage(
                    task: task,
                  ));
        }
      default:
        throw 'No Page Found!!';
    }
  }
}
