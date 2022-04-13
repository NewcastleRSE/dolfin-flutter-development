import 'package:animate_do/animate_do.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/presentation/widgets/child_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/bloc/auth/authentication_cubit.dart';
import 'package:dolfin_flutter/bloc/connectivity/connectivity_cubit.dart';
import 'package:dolfin_flutter/data/models/task_model.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/screens/onboarding.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/myindicator.dart';
import 'package:dolfin_flutter/presentation/widgets/mysnackbar.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/presentation/widgets/task_container.dart';
import 'package:dolfin_flutter/shared/constants/assets_path.dart';
import 'package:dolfin_flutter/shared/constants/consts_variables.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:dolfin_flutter/shared/services/notification_service.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

class ChildInfoPage extends StatefulWidget {
  const ChildInfoPage({Key? key}) : super(key: key);

  @override
  State<ChildInfoPage> createState() => _ChildInfoPageState();
}

class _ChildInfoPageState extends State<ChildInfoPage> {
  static var currentdate = DateTime.now();
  static bool? notificationPrefs = true;

  final TextEditingController _usercontroller = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);

  @override
  void initState() {
    super.initState();

    NotificationsHandler.requestpermission(context);
  }

  @override
  void dispose() {
    super.dispose();

    _usercontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authenticationCubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    final user = FirebaseAuth.instance.currentUser;
    String username = user!.isAnonymous ? 'Anonymous' : 'User';

    return Scaffold(
        body: MultiBlocListener(
            listeners: [
          BlocListener<ConnectivityCubit, ConnectivityState>(
              listener: (context, state) {
            if (state is ConnectivityOnlineState) {
              MySnackBar.error(
                  message: 'You Are Online Now ',
                  color: Colors.green,
                  context: context);
            } else {
              MySnackBar.error(
                  message: 'Please Check Your Internet Connection',
                  color: Colors.red,
                  context: context);
            }
          }),
          BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              if (state is UnAuthenticationState) {
                Navigator.pushNamedAndRemoveUntil(
                    context, welcomepage, (route) => false);
              }
            },
          )
        ],
            child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationLoadingState) {
                  return const MyCircularIndicator();
                }

                return SafeArea(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.displayName != null
                                  ? 'Hello ${user.displayName}'
                                  : ' Hello $username',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 15.sp),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                homepage,
                              );
                            },
                            child: Icon(
                              Icons.home_rounded,
                              size: 25.sp,
                              color: AppColours.black,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          InkWell(
                            onTap: () {
                              _showBottomSheet(context, authenticationCubit);
                            },
                            child: Icon(
                              Icons.settings,
                              size: 25.sp,
                              color: AppColours.black,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                onboarding,
                              );
                            },
                            child: Icon(
                              Icons.help,
                              size: 25.sp,
                              color: AppColours.black,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('MMMM, dd').format(currentdate),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 17.sp),
                          ),
                          const Spacer(),
                          MyButton(
                            color: AppColours.green,
                            width: 40.w,
                            title: 'Edit Child',
                            func: () {
                              Navigator.pushNamed(
                                context,
                                addchildpage,
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Expanded(
                          child: StreamBuilder(
                        stream: FireStoreCrud().getChildren(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ChildModel>> snapshot) {
                          if (snapshot.hasError) {
                            return _nodatawidget();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const MyCircularIndicator();
                          }

                          return snapshot.data!.isNotEmpty
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var child = snapshot.data![index];
                                    Widget _taskcontainer = ChildContainer(
                                      id: child.id,
                                      studyID: child.studyID,
                                      name: child.name,
                                      dob: child.dob,
                                    );
                                    return InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, addchildpage,
                                              arguments: child);
                                        },
                                        child: index % 2 == 0
                                            ? BounceInLeft(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                child: _taskcontainer)
                                            : BounceInRight(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                child: _taskcontainer));
                                  },
                                )
                              : _nodatawidget();
                        },
                      )),
                    ],
                  ),
                ));
              },
            )));
  }

  Future<dynamic> _showBottomSheet(
      BuildContext context, AuthenticationCubit authenticationCubit) {
    var user = FirebaseAuth.instance.currentUser!.isAnonymous;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: ((context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'User Display Name',
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    (user)
                        ? Container()
                        : MyTextfield(
                            hint: '',
                            icon: Icons.person,
                            validator: (value) {},
                            textEditingController: _usercontroller),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'Notification Preferences',
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontSize: 12.sp),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Daily Notifications Enabled: ',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Checkbox(
                        checkColor: AppColours.dark_blue,
                        activeColor: AppColours.white,
                        value: notificationPrefs,
                        onChanged: (bool? value) {
                          setState(() {
                            notificationPrefs = value;
                          });
                        },
                      ),
                    ]),
                    SizedBox(
                      height: 3.h,
                    ),
                    (user)
                        ? Container()
                        : BlocBuilder<AuthenticationCubit, AuthenticationState>(
                            builder: (context, state) {
                              if (state is UpdateProfileLoadingState) {
                                return const MyCircularIndicator();
                              }

                              return MyButton(
                                color: Colors.green,
                                width: 80.w,
                                title: "Update Profile",
                                func: () {
                                  if (_usercontroller.text == '') {
                                    MySnackBar.error(
                                        message: 'Name shoud not be empty!!',
                                        color: Colors.red,
                                        context: context);
                                  } else {
                                    authenticationCubit.updateUserInfo(
                                        _usercontroller.text, context);
                                    setState(() {});
                                  }
                                },
                              );
                            },
                          ),
                    SizedBox(
                      height: 1.h,
                    ),
                    MyButton(
                      color: Colors.red,
                      width: 80.w,
                      title: "Log Out",
                      func: () {
                        authenticationCubit.signout();
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _nodatawidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            MyAssets.clipboard,
            height: 30.h,
          ),
          SizedBox(height: 3.h),
          Text(
            'You have not added any children, add a child to continue',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
