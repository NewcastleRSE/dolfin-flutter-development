import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/presentation/widgets/child_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/bloc/auth/authentication_cubit.dart';
import 'package:dolfin_flutter/bloc/connectivity/connectivity_cubit.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/myindicator.dart';
import 'package:dolfin_flutter/presentation/widgets/mysnackbar.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/constants/assets_path.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:dolfin_flutter/shared/services/notification_service.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static var currentdate = DateTime.now();
  static bool? notificationPrefs = true;

  final TextEditingController _usercontroller = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);

  late bool past3;
  String _versionNo = "v";
  String _buildNo = "b";

  @override
  void initState() {
    super.initState();

    past3 = checkDailyNotificationsVisibility();

    // save parent ID and FCM token to Firestore for push notifications
    // get FCM token
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      // Save the initial token to the database
      saveFCMTokenToDatabase(token!);
    });

    //   // if daily notifications has not yet been set, set to true
    // if (firstLogin() == true) {
    //   updateDailyNotifications(true);
    // }

    // Any time the token refreshes, store this in the database too
    FirebaseMessaging.instance.onTokenRefresh.listen(saveFCMTokenToDatabase);

    // IOS configuration of cloud messaging
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // When user clicks background notification and opens app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    // push notification when app running in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(message.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pushNamed(context, homepage);
                  },
                )
              ],
            );
          });
    });
  }

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  Future<void> saveFCMTokenToDatabase(String token) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('parents')
        .doc(userId)
        .set({
          'tokens': FieldValue.arrayUnion([token])
        }, SetOptions(merge: true))
        .then((result) {})
        .catchError((onError) {
          print('error saving fcm token');
          print(onError);
        });
  }

  Future<bool> updateDailyNotifications(bool dailyNotifications) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('parents').doc(userId).set(
        {'dailyNotifications': dailyNotifications},
        SetOptions(merge: true)).then((result) {
      return true;
    }).catchError((onError) {
      print('error saving fcm token');
      print(onError);
      return false;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dailyNotifications', dailyNotifications);

    return true;
  }

  bool checkDailyNotificationsVisibility() {

    var childrenSnapshot = FireStoreCrud()
        .getChildren(parentID: FirebaseAuth.instance.currentUser!.uid);
    // today's date
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    bool past3 = false;

    childrenSnapshot.listen((children) {
      for (final child in children) {
        DateTime dischargeDate = DateTime.parse(child.dischargeDate);

        // if it has been over 3 months since hospital discharge show option to turn off daily reminders
        if (daysBetween(dischargeDate, today) >= 84) {
          past3 = true;
          break;
        }
      }
    });
    return past3;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
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
                            DateFormat('dd MMMM').format(currentdate),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 17.sp),
                          ),
                          const Spacer(),
                          MyButton(
                            color: AppColours.dark_blue,
                            width: 40.w,
                            title: '+ Add Child',
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
                        stream: FireStoreCrud().getChildren(
                            parentID: FirebaseAuth.instance.currentUser!.uid),
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
                              ? Column(children: [
                                  _showInstructionText(
                                      context, snapshot.data!.isNotEmpty),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var child = snapshot.data![index];
                                      Widget _childcontainer = ChildContainer(
                                        id: child.id,
                                        studyID: child.studyID,
                                        name: child.name,
                                        dob: child.dob,
                                      );
                                      return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, childinfopage,
                                                arguments: child);
                                          },
                                          child: index % 2 == 0
                                              ? BounceInLeft(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  child: _childcontainer)
                                              : BounceInRight(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  child: _childcontainer));
                                    },
                                  )
                                ])
                              : _nodatawidget();
                        },
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: FutureBuilder<PackageInfo>(
                              future: _getPackageInfo(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<PackageInfo> snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('ERROR');
                                } else if (!snapshot.hasData) {
                                  return const Text('Loading...');
                                }

                                final data = snapshot.data!;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'v${data.version}-${data.buildNumber}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ));
              },
            )));
  }

  Future<dynamic> _showBottomSheet(
      BuildContext context, AuthenticationCubit authenticationCubit) async {
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
                      height: 5.h,
                    ),
                    Text(
                      'User display name:',
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
                      height: 5.h,
                    ),
                    Text(
                      'I want to receive reminders:',
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    notificationsSelector(),
                    SizedBox(
                      height: 4.h,
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
                                        message: 'Name should not be empty!!',
                                        color: Colors.red,
                                        context: context);
                                  } else {
                                    authenticationCubit.updateUserInfo(
                                        _usercontroller.text, context);
                                    setState(() {});
                                    showDialog<String>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              content: const Text(
                                                  "Thank you, your details have been updated."),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                        context, homepage);
                                                  },
                                                  child: const Text('OK'),
                                                )
                                              ],
                                            ));
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
            'You have not added any children to the app yet, please add a child to continue',
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

enum NotificationsOptions { daily, weekly }

class notificationsSelector extends StatefulWidget {
  notificationsSelector({Key? key}) : super(key: key);

  @override
  _notificationsSelectorState createState() => _notificationsSelectorState();
}

class _notificationsSelectorState extends State<notificationsSelector> {
  NotificationsOptions _notifications = NotificationsOptions.daily;

  @override
  void initState() {
    super.initState();
    getDailyNotificationPref();
  }

  // check shared prefs to see if user has previously checked or unchecked this
  getDailyNotificationPref() async {
    // adjust notification preferences in Firestore
    var collection = FirebaseFirestore.instance.collection('parents');
    var docSnapshot =
        await collection.doc(FirebaseAuth.instance.currentUser?.uid).get();
    // note thinks this field is a String evn though saved and updated as bool in Firestore
    bool notifications = true;
    if (docSnapshot.exists && docSnapshot.get('dailyNotifications')) {
      notifications = docSnapshot.get('dailyNotifications');
    } else {
      // save to Firestore initial daily preference
      saveDailyNotificationsPref(true);
    }
    setState(() {
      // set to true if not value already set
      if (notifications == true) {
        _notifications = NotificationsOptions.daily;
      } else {
        _notifications = NotificationsOptions.weekly;
      }
    });
  }

  saveDailyNotificationsPref(value) async {
    FirebaseFirestore.instance
        .collection('parents')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({'dailyNotifications': true}, SetOptions(merge: value));
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Daily'),
          leading: Radio(
            value: NotificationsOptions.daily,
            groupValue: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = NotificationsOptions.daily;
                // saveDailyNotificationsPref(true);

                // adjust notification preferences in Firestore
                FirebaseFirestore.instance
                    .collection('parents')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .set({'dailyNotifications': true}, SetOptions(merge: true));
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Weekly'),
          leading: Radio(
            value: NotificationsOptions.weekly,
            groupValue: _notifications,
            onChanged: (value) {
              setState(() {
                // adjust notification preferences in Firestore
                FirebaseFirestore.instance
                    .collection('parents')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .set(
                        {'dailyNotifications': false}, SetOptions(merge: true));
                _notifications = NotificationsOptions.weekly;
                // saveDailyNotificationsPref(false);
              });
            },
          ),
        ),
      ],
    );
  }
}

Widget _showInstructionText(BuildContext context, bool isNotEmpty) {
  if (isNotEmpty) {
    return Column(children: [
      Text(
        "Tap on your child's name below to submit data or view their records.",
        style:
            Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
      ),
      SizedBox(
        height: 3.h,
      ),
    ]);
  } else {
    return Container();
  }
}

//
// class _dailyNotificationsCheckState extends State<dailyNotificationsCheck> {
//   bool? isChecked = true;
//
//   @override
//   void initState() {
//     super.initState();
//     getDailyNotificationPref();
//   }
//
//   // check shared prefs to see if user has previously checked or unchecked this
//   getDailyNotificationPref() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? value = prefs.getBool('dailyNotifications');
//     setState(() {
//       // set to true if not value already set
//       isChecked = value ?? true;
//     });
//   }
//
//   saveDailyNotificationsPref(value) async {
//     // store value in shared prefs
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('dailyNotifications', value);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Checkbox(
//       checkColor: AppColours.dark_blue,
//       activeColor: AppColours.white,
//       value: isChecked,
//       onChanged: (bool? value) {
//         setState(() {
//           isChecked = value;
//           // store value in shared prefs
//           saveDailyNotificationsPref(value);
//
//           // adjust notification preferences in Firestore
//           FirebaseFirestore.instance
//               .collection('parents')
//               .doc(FirebaseAuth.instance.currentUser?.uid)
//               .set({'dailyNotifications': value}, SetOptions(merge: true));
//         });
//       },
//     );
//   }
// }
