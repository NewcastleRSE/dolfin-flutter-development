import 'dart:async';
import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:dolfin_flutter/presentation/widgets/record_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:dolfin_flutter/shared/constants/assets_path.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:dolfin_flutter/shared/services/notification_service.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class ChildInfoPage extends StatefulWidget {
  final ChildModel? child;

  const ChildInfoPage({
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<ChildInfoPage> createState() => _ChildInfoPageState();
}

class _ChildInfoPageState extends State<ChildInfoPage> {
  late String _childName;
  static var currentdate = DateTime.now();

  final TextEditingController _usercontroller = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);

  @override
  void initState() {
    super.initState();
    _childName = widget.child != null ? widget.child!.name : "Child Name";
  }

  Future<HttpsCallableResult> _getChildInfo() async {
    final functions = FirebaseFunctions.instanceFor(region: "europe-west2");
    var checkChild = functions.httpsCallable('checkChild');
    var childDetails = await checkChild
        .call(<String, String>{"child_id": widget.child!.id}).catchError(
            (error) => nope(error));
    return childDetails;
  }

  Future<HttpsCallableResult> nope(var error) {
    print(error.code);
    print(error.details);
    print(error.message);
    return Future<HttpsCallableResult>.error(error);
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

    DateTime today = DateTime.now();
    DateTime lastWeek = today.subtract(const Duration(days: 7));

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
                              "Records",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
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
                          SizedBox(
                              width: 80.0,
                              child: Text(
                                _childName,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(fontSize: 13.sp),
                              )),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, addchildpage,
                                  arguments: widget.child);
                            },
                            child: Icon(Icons.edit, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12),
                                primary: AppColours.light_blue),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, weightrecordspage,
                                  arguments: widget.child);
                            },
                            child: Icon(Icons.add_chart_rounded,
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12),
                                primary: AppColours.light_blue),
                          ),
                          HospitalAdmissionWidget(child: widget.child)
                        ],
                      ),
//-------------------------------------------------------------------------------

                      SizedBox(
                        height: 4.h,
                      ),
                      FutureBuilder<HttpsCallableResult>(
                        future: _getChildInfo(),
                        builder: (BuildContext context,
                            AsyncSnapshot<HttpsCallableResult> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('ERROR');
                          } else if (!snapshot.hasData) {
                            return const Column(children: [
                              Center(
                                  child: Text('Loading...',
                                      textAlign: TextAlign.center))
                            ]);
                          }

                          final data = snapshot.data!;
                          print(data.data);
// if startOfWeek is negative this indicates that the user is in the first week of weekly forms so should not see daily forms or weekly forms
// if showing forms
if  (data.data["startOfWeek"] >= 0) {



                          bool weekly = data.data["showWeeklyForms"];
                          //weekly = true;

                          bool showButton = true;
                          String dueDate = "";

                          var dateString = data.data["lastWeekSubmitted"];
                          if (dateString != "0000-00-00") {
                            var parsedDate = DateTime.parse(dateString);
                            var now = DateTime.now();
                            var difference = now.difference(parsedDate).inDays;
                            if (difference < 7) {
                              showButton = false;

                              var nextDate = parsedDate.add(Duration(days: 7));
                              dueDate =
                                  DateFormat("dd-MM-yyyy").format(nextDate);
                            }
                          }

                          String displayText = showButton
                              ? "Your next weekly supplement check is due. Please click the button below to submit your child's dosage info for the last 7 days."
                              : "You have already submitted your weekly supplement data for ${widget.child!.name} this week.";

                          if (weekly) {
                            return Column(children: [
                              Text(
                                displayText,
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 18.sp),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              showButton
                                  ? MyButton(
                                      color: AppColours.dark_blue,
                                      width: 60.w,
                                      title: '+ Add Weekly Record',
                                      func: () {
                                        Navigator.pushNamed(
                                            context, addweeklyrecordpage,
                                            arguments: widget.child);
                                      },
                                    )
                                  : Text(
                                      "Your next supplement check is due on: $dueDate",
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(fontSize: 18.sp),
                                    ),
                            ]);
                          
                          } else {
                            return Expanded(
                                child: StreamBuilder(
                              stream: FireStoreCrud().getRecordsRange(
                                  childID: widget.child!.id,
                                  start: lastWeek,
                                  end: today),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<RecordModel>> snapshot) {
                                if (snapshot.hasError) {
                                  return _nodatawidget();
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const MyCircularIndicator();
                                }

                                List<RecordModel>? records = formatRecordData(
                                    snapshot.data, lastWeek, today);

                                return SingleChildScrollView(
                                    child: Column(children: [
                                  Text(
                                    "Below are your child's supplement records for the last seven days. Tap on a record with a blue button to add/edit that record.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  // @imre-patch-8: remove this text box
                                  // Container(
                                  //   margin: EdgeInsets.all(10),
                                  //   padding: EdgeInsets.all(10),
                                  //   alignment: Alignment.center,
                                  //   decoration: BoxDecoration(
                                  //       border: Border.all(
                                  //           color: AppColours.red,
                                  //           // Set border color
                                  //           width: 3.0),
                                  //       // Set border width
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(
                                  //               10.0)) // Make rounded corner of border
                                  //       ),
                                  //   child: Text(
                                  //       "Please only start adding supplement records once your child has been discharged home from hospital."),
                                  // ),
                                  // end of @imre-patch-8
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: records!.length,
                                    itemBuilder: (context, index) {
                                      var record = records[index];
                                      Widget _taskcontainer = RecordContainer(
                                          record: record, child: widget.child);
                                      return InkWell(
                                          onTap: () {
                                            record.id == "0"
                                                ? // New Record
                                                Navigator.pushNamed(
                                                    context, addrecordpage,
                                                    arguments: <String,
                                                        dynamic>{
                                                        "data": widget.child,
                                                        "date": record.date
                                                      })
                                                : //Edit Record
                                                index <= 1
                                                    ? Navigator.pushNamed(
                                                        context, addrecordpage,
                                                        arguments: <String,
                                                            dynamic>{
                                                            "data": record,
                                                            "date":
                                                                DateTime.now()
                                                          })
                                                    : null;
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
                                ]));
                              },
                            ));
                          }
} else {
  return _norecordswidget();
}
                        },
                      ),
                    ],
                  ),
                ));
              },
            )));
  }

  List<RecordModel>? formatRecordData(
      List<RecordModel>? record, DateTime start, DateTime end) {
        List<RecordModel>? results = [];

        DateTime currentDate = end;

        String child = widget.child!.id;
        String studyID = widget.child!.studyID;

        for (int i = 0; i < 7; i++) {
          bool found = false;

          if (record != null) {
            for (RecordModel r in record) {
              if (r.date.isSameDate(currentDate)) {
                results.add(r);
                found = true;
              }
            }
          }

          if (!found) {
            results.add(RecordModel(
                id: "0",
                child: child,
                studyID: studyID,
                date: currentDate,
                dateSubmitted: DateTime.now(),
                supplement: SupplementOptions.fullDose,
                reasons: [],
                otherReason: ""));
          }

          currentDate = currentDate.subtract(Duration(days: 1));
        }

      return results;
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
          SizedBox(height: 5.h),
          Text(
            'You currently have no records for this child. Add a record to continue.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

    Widget _norecordswidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            MyAssets.clipboard,
            height: 30.h,
          ),
          SizedBox(height: 5.h),
          Text(
            'You currently have no records due.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}

class HospitalAdmissionWidget extends StatelessWidget {
  const HospitalAdmissionWidget({Key? key, this.child}) : super(key: key);

  final ChildModel? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text(
              'Has your child had any new unplanned hospital admissions in the last week?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // save entry in Firestore db for this child and today's date
                var study_id = child!.studyID;
                var child_id = child!.id;
                FireStoreCrud().addChildHospitalAdmission(child_id, study_id);
                showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => AlertDialog(
                          content: const Text(
                              "Thank you for letting us know. A member of your local clinical team will be in touch to ask you about this."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ));
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
          ],
        ),
      ),
      child: Icon(Icons.domain_add_outlined, color: Colors.white),
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(12),
          primary: AppColours.light_blue),
    );
  }
}
