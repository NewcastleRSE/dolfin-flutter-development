import 'package:animate_do/animate_do.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:dolfin_flutter/presentation/widgets/record_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // todo check this
    // NotificationsHandler.requestpermission(context);
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
                              "Records",
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
                            _childName,
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 17.sp),
                          ),
                          const Spacer(),
                          MyButton(
                            color: AppColours.light_blue,
                            width: 40.w,
                            title: 'Edit Child',
                            func: () {
                              Navigator.pushNamed(context, addchildpage,
                                  arguments: widget.child);
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Center(
                        child: MyButton(
                          color: AppColours.dark_blue,
                          width: 60.w,
                          title: '+ Add New Record',
                          func: () {
                            Navigator.pushNamed(context, addrecordpage,
                                arguments: widget.child);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Expanded(
                          child: StreamBuilder(
                        stream: FireStoreCrud()
                            .getRecords(childID: widget.child!.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<RecordModel>> snapshot) {
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
                                    Widget _taskcontainer = RecordContainer(
                                        id: child.id,
                                        date: child.date,
                                        supplement: "Yes",
                                        weight: "9kg");
                                    return InkWell(
                                        onTap: () {
                                          // Navigator.pushNamed(
                                          //     context, addchildpage,
                                          //     arguments: child);
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
                .headline1!
                .copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
