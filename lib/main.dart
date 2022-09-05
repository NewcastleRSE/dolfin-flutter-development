import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/bloc/connectivity/connectivity_cubit.dart';
import 'package:dolfin_flutter/bloc/onboarding/onboarding_cubit.dart';
import 'package:dolfin_flutter/presentation/screens/homepage.dart';
import 'package:dolfin_flutter/presentation/screens/onboarding.dart';
import 'package:dolfin_flutter/presentation/screens/welcome_page.dart';
import 'package:dolfin_flutter/presentation/widgets/myindicator.dart';
import 'package:dolfin_flutter/shared/constants/consts_variables.dart';
import 'package:dolfin_flutter/shared/route.dart';
import 'package:dolfin_flutter/shared/styles/themes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bloc/auth/authentication_cubit.dart';

import 'package:flutter/widgets.dart';

Future<void> main() async {

  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  // push notification when in background
  FirebaseMessaging.onBackgroundMessage(_firebasePushHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });

  final prefs = await SharedPreferences.getInstance();
  final bool? seen = prefs.getBool('seen');

  // if (kReleaseMode) {
  //   await SentryFlutter.init(
  //     (options) {
  //       options.dsn =
  //           'https://e506dae22f9c478a93be1d6467770cd6@o1080315.ingest.sentry.io/6324285';
  //       // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //       // We recommend adjusting this value in production.
  //       options.tracesSampleRate = 1.0;
  //     },
  //     appRunner: () => runApp(MyApp(
  //       seen: seen,
  //       approute: AppRoute(),
  //     )),
  //   );
  // } else {
  //   runApp(MyApp(
  //     seen: seen,
  //     approute: AppRoute(),
  //   ));
  // }

  runApp(MyApp(
          seen: seen,
          approute: AppRoute(),
        ));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.approute, required this.seen})
      : super(key: key);

  final AppRoute approute;
  final bool? seen;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                lazy: false,
                create: (context) =>
                    ConnectivityCubit()..initializeConnectivity()),
            BlocProvider(
              create: (context) => OnboardingCubit(),
            ),
            BlocProvider(create: (context) => AuthenticationCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DOLFIN App',
            themeMode: ThemeMode.light,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            onGenerateRoute: approute.generateRoute,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const MyCircularIndicator();
                }
                if (snapshot.hasData) {
                  return const HomePage();
                }
                if (seen != null) {
                  return const WelcomePage();
                }
                return const OnboardingPage();
              },
            ),
          ),
        );
      },
    );
  }
}


Future<void> _firebasePushHandler(RemoteMessage message) async{
  print('Message from push notification whilst running in background is ${message.data}');
}