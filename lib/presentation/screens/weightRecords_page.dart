import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/weight_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
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
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:url_launcher/url_launcher.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class WeightRecordsPage extends StatefulWidget {
  final ChildModel? child;

  const WeightRecordsPage({
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<WeightRecordsPage> createState() => _WeightRecordsPageState();
}

class _WeightRecordsPageState extends State<WeightRecordsPage> {
  late String _childName;
  static var currentdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _childName = widget.child != null ? widget.child!.name : "Child Name";
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            _buildAppBar(context),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                    width: 150.0,
                                    child: Text(
                                      _childName,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(fontSize: 17.sp),
                                    )),
                                const Spacer()
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Expanded(
                                child: StreamBuilder(
                              stream: FireStoreCrud()
                                  .getWeights(childID: widget.child!.id),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<WeightModel>> snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('ERROR');
                                } else if (!snapshot.hasData) {
                                  return Column(children: [
                                    Center(
                                        child: Text('Loading...',
                                            textAlign: TextAlign.center))
                                  ]);
                                }

                                final records = snapshot.data!;
                                var instructions = "";

                                String formatDate(DateTime date) =>
                                    new DateFormat("dd/MM/yyyy").format(date);

                                var lastDate = records[records.length - 1].date;

                                if (records.length == 0) {
                                  instructions =
                                      "You have not submitted any weight data for " +
                                          widget.child!.name +
                                          " yet";
                                } else {
                                  instructions =
                                      "You last submitted a weight reading on " +
                                          formatDate(lastDate) +
                                          ". We recommend submitting a reading once a month.\n";
                                }

                                bool allowSubmit = true;

                                var difference =
                                    DateTime.now().difference(lastDate).inHours;
                                if (difference <= 24) {
                                  allowSubmit = false;
                                }

                                return SingleChildScrollView(
                                    child: Column(children: [
                                  Text(instructions,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 14.sp)),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  MyButton(
                                    color: AppColours.dark_blue,
                                    width: 60.w,
                                    title: '+ Add Weight Record',
                                    func: () {
                                      Navigator.pushNamed(
                                          context, addweightpage,
                                          arguments: widget.child);
                                    },
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    "Below are your child's weight records. Tap on a record with a blue button to edit that record.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                            child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text("Date",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2!
                                                        .copyWith(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)))),
                                        TableCell(
                                            child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text("Weight",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2!
                                                        .copyWith(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)))),
                                        TableCell(
                                            child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text("Scoops",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2!
                                                        .copyWith(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)))),
                                      ]),
                                    ],
                                  ),
                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: records.length,
                                      itemBuilder: (context, index) {
                                        var record = records[index];
                                        return Table(columnWidths: {
                                          0: FlexColumnWidth(3),
                                          1: FlexColumnWidth(2),
                                          2: FlexColumnWidth(2),
                                        }, children: [
                                          TableRow(children: [
                                            TableCell(
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Text(
                                                        formatDate(record.date),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2!
                                                            .copyWith(
                                                                fontSize:
                                                                    14.sp)))),
                                            TableCell(
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Text(record.weight,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2!
                                                            .copyWith(
                                                                fontSize:
                                                                    14.sp)))),
                                            TableCell(
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Text(
                                                        record.numScoops,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2!
                                                            .copyWith(
                                                                fontSize:
                                                                    14.sp)))),
                                          ])
                                        ]);
                                      }),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'The DOLFIN supplement dosing chart can be found ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(fontSize: 14.sp),
                                        ),
                                        TextSpan(
                                          text: '[here]',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  fontSize: 14.sp,
                                                  color: AppColours.light_blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launch(
                                                  'https://www.npeu.ox.ac.uk/dolfin/parents/resources');
                                            },
                                        ),
                                        TextSpan(
                                          text:
                                              ' and is also included in your Parent Discharge Pack.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  )
                                ]));
                              },
                            ))
                          ])));
            })));
  }

  Row _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            size: 30.sp,
          ),
        ),
        Text(
          "Weight Records",
          overflow: TextOverflow.ellipsis,
          style:
              Theme.of(context).textTheme.headline1!.copyWith(fontSize: 15.sp),
        ),
        const SizedBox()
      ],
    );
  }

  List<WeightModel>? formatRecordData(
      List<WeightModel>? record, DateTime start, DateTime end) {
    List<WeightModel>? results = [];

    DateTime currentDate = end;

    String child = widget.child!.id;
    String studyID = widget.child!.studyID;

    for (int i = 0; i < 7; i++) {
      bool found = false;

      if (record != null) {
        for (WeightModel r in record) {
          if (r.date.isSameDate(currentDate)) {
            results.add(r);
            found = true;
          }
        }
      }

      if (!found) {
        results.add(WeightModel(
            id: "0",
            child: child,
            studyID: studyID,
            date: currentDate,
            weight: "1kg",
            numScoops: "2"));
      }

      currentDate = currentDate.subtract(Duration(days: 1));
    }

    return results;
  }
}
