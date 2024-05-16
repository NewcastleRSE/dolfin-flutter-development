import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/bloc/auth/authentication_cubit.dart';
import 'package:dolfin_flutter/bloc/connectivity/connectivity_cubit.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/myindicator.dart';
import 'package:dolfin_flutter/presentation/widgets/mysnackbar.dart';
import 'package:dolfin_flutter/shared/constants/assets_path.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authcubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: AppColours.white,
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccessState) {
            Navigator.pushReplacementNamed(context, homepage);
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoadingState) {
            return const MyCircularIndicator();
          }

          if (state is! AuthenticationSuccessState) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 12.h,
                    ),
                    BounceInDown(
                        duration: const Duration(milliseconds: 1500),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            MyAssets.welcomesketch,
                            fit: BoxFit.cover,
                          ),
                        )),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'Welcome',
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(letterSpacing: 3),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Welcome to the DOLFIN App',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            letterSpacing: 3,
                            fontSize: 10.sp,
                            wordSpacing: 2,
                          ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    MyButton(
                      color: AppColours.dark_blue,
                      width: 70.w,
                      title: 'Login',
                      func: () {
                        Navigator.pushNamed(context, loginpage);
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    MyButton(
                      color: AppColours.light_blue,
                      width: 70.w,
                      title: 'Sign Up',
                      func: () {
                        Navigator.pushNamed(context, signuppage);
                      },
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Container _myOutlinedButton(BuildContext context, AuthenticationCubit cubit,
      ConnectivityCubit connectivityCubit) {
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          border: Border.all(color: Colors.deepPurple, width: 2)),
      child: MaterialButton(onPressed: () {
        if (connectivityCubit.state is ConnectivityOnlineState) {
          cubit.signinanonym();
        } else {
          MySnackBar.error(
              message: 'Please Check Your Internet Connection',
              color: Colors.red,
              context: context);
        }
      }),
    );
  }
}
