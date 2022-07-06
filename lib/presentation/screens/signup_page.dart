import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/bloc/auth/authentication_cubit.dart';
import 'package:dolfin_flutter/bloc/connectivity/connectivity_cubit.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/myindicator.dart';
import 'package:dolfin_flutter/presentation/widgets/mysnackbar.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/constants/assets_path.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:dolfin_flutter/shared/validators.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namecontroller;
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;

  @override
  void initState() {
    super.initState();
    _namecontroller = TextEditingController();
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authcubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: AppColours.white,
      appBar: AppBar(
        backgroundColor: AppColours.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: AppColours.black,
            size: 30,
          ),
        ),
      ),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationErrortate) {
            // Showing the error message if the user has entered invalid credentials
            MySnackBar.error(
                message: state.error.toString(),
                color: Colors.amber,
                context: context);
            throw StateError(state.error.toString());
          }

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
                child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: BounceInDown(
                    duration: const Duration(milliseconds: 1500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
                                    fontSize: 20.sp,
                                    letterSpacing: 2,
                                  ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),

                        Text(dotenv.get('NPEU_URL', fallback: 'default')),
                        Text(
                          'Create a new account. Please make sure you use the email'
                              ' you originally signed up to the trial with.',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  fontSize: 12.sp,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        MyTextfield(
                          hint: 'Full Name',
                          icon: Icons.person,
                          keyboardtype: TextInputType.name,
                          validator: (value) {
                            return value!.length < 3 ? 'Unvalid Name' : null;
                          },
                          textEditingController: _namecontroller,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        MyTextfield(
                          hint: 'Email Address',
                          icon: Icons.email,
                          keyboardtype: TextInputType.emailAddress,
                          validator: (value) {
                            return !Validators.isValidEmail(value!)
                                ? 'Enter a valid email'
                                : null;
                          },
                          textEditingController: _emailcontroller,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        MyTextfield(
                          hint: 'Password',
                          icon: Icons.password,
                          obscure: true,
                          keyboardtype: TextInputType.text,
                          validator: (value) {
                            return value!.length < 6
                                ? "Enter min. 6 characters"
                                : null;
                          },
                          textEditingController: _passwordcontroller,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        MyButton(
                          color: AppColours.light_blue,
                          width: 80.w,
                          title: 'Sign Up',
                          func: () {
                            if (connectivitycubit.state
                                is ConnectivityOnlineState) {
                              _signupewithemailandpass(context, authcubit);
                            } else {
                              MySnackBar.error(
                                  message:
                                      'Please Check Your Internet Connection',
                                  color: Colors.red,
                                  context: context);
                            }
                          },
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an Account ?',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, loginpage);
                              },
                              child: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 9.sp,
                                      color: AppColours.dark_blue,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
          }
          return Container();
        },
      ),
    );
  }

  Container _myDivider() {
    return Container(
      width: 27.w,
      height: 0.2.h,
      color: AppColours.black,
    );
  }

  void _signupewithemailandpass(context, AuthenticationCubit cubit) {

    // is form complete and email registered with Oxford?
    if (_formKey.currentState!.validate()) {
      checkEmail( _emailcontroller.text).then((exists) {

       if (exists == 1) {
          cubit.register(
              fullname: _namecontroller.text,
              email: _emailcontroller.text,
              password: _passwordcontroller.text);
        } else if(exists == 2) {
          print('parent does not exist in study');
          MySnackBar.error(
              message: "Problem with email, please check you have entered the email you"
                  " used when you signed up for the study",
              color: Colors.red,
              context: context);
        }
      });
    }
  }

  // http request to check child's ID is valid
  Future<num> checkEmail(email) async {
    try {
      // acquire jwt from NPEU
      await dotenv.load();

      MySnackBar.error( message: dotenv.get('NPEU_URL'),
          color: Colors.blue,
          context: context);

      var baseUrl = dotenv.get('NPEU_URL');
      var authUrl = 'https://' + baseUrl + '/identityauthority/connect/token';

      var body = {
        'client_id': dotenv.get('CLIENT_ID'),
        'client_secret': dotenv.get('CLIENT_SECRET'),
        'scope': dotenv.get('SCOPE'),
        'grant_type': dotenv.get('GRANT_TYPE')
      };

      var authResponse = await http.post(
          Uri.parse(authUrl),
          body:body);
      print(authResponse);
      MySnackBar.error( message: authResponse.toString(),
          color: Colors.blue,
          context: context);
      if (authResponse.statusCode != 200) {
        MySnackBar.error(
            message: authResponse.statusCode.toString(),
            color: Colors.blue,
            context: context);
        return 3;
      } else {
        var jwt = jsonDecode(authResponse.body)['access_token'];

        // check if email is valid
        var queryParameters = {'Email': email};
        var url = Uri.https(baseUrl,
            '/dolfindata/api/participant/confirm', queryParameters);


        // returns true or false to indicate if email is valid
        final response = await http.get(url,
            headers: {'Authorization': 'Bearer $jwt'});

        if (response.statusCode == 200) {
          bool b = response.body.toLowerCase() == 'true';
          if(b == true) {
            return 1;
          } else {
            return 2;
          }
        } else {
          MySnackBar.error(
              message: authResponse.statusCode.toString(),
              color: Colors.red,
              context: context);
          return 3;
        }
      }
    } catch (err) {
      print(err);
      MySnackBar.error(
          message: err.toString(),
          color: Colors.blue,
          context: context);
      return 3;
    }



  }
}
