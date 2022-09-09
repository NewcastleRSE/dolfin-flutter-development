import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';

import '../widgets/mysnackbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddChildPage extends StatefulWidget {
  final ChildModel? child;

  const AddChildPage({
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends State<AddChildPage> {
  get isEditMode => widget.child != null;

  late TextEditingController _trialIDcontroller;
  late TextEditingController _namecontroller;

  late DateTime dateOfBirth;
  late DateTime dischargeDate;
  late DateTime dueDate;

  late bool recruitedAfterDischarge;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _namecontroller =
        TextEditingController(text: isEditMode ? widget.child!.name : '');
    _trialIDcontroller =
        TextEditingController(text: isEditMode ? widget.child!.studyID : '');
    dateOfBirth =
    isEditMode ? DateTime.parse(widget.child!.dob) : DateTime.now();
    // dischargeDate = isEditMode
    //     ? DateTime.parse(widget.child!.dischargeDate)
    //     : DateTime.now();
    // recruitedAfterDischarge = false;
  }

  @override
  void dispose() {
    super.dispose();
    _namecontroller.dispose();
    _trialIDcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _buildform(context),
          ),
        ),
      ),
    );
  }

  Form _buildform(BuildContext context) {
    return Form(
      key: _formKey,
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
          Text(
            "Thank you for taking part in the DOLFIN trial. Please enter your child's details below. You will need to know their study number, which should have been provided when you registered.",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Study Number',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            readonly: isEditMode ? true : false,
            hint: "Study Number",
            icon: Icons.title,
            showicon: false,
            validator: (value) {
              return value!.isEmpty
                  ? "Please Enter Your Child's Study Number."
                  : null;
            },
            textEditingController: _trialIDcontroller,
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Name',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: "First Name",
            icon: Icons.title,
            showicon: false,
            validator: (value) {
              return value!.isEmpty
                  ? "Please Enter Your Child's First Name"
                  : null;
            },
            textEditingController: _namecontroller,
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Date of birth',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: DateFormat('dd/MM/yyyy').format(dateOfBirth),
            icon: Icons.calendar_today,
            readonly: true,
            showicon: false,
            validator: (value) {},
            ontap: () {
              !isEditMode ? _showdatepickerdob() : null;
            },
            textEditingController: TextEditingController(),
            keyboardtype: TextInputType.none,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                color: isEditMode ? AppColours.green : AppColours.dark_blue,
                width: isEditMode ? 50.w : 40.w,
                title: isEditMode ? "Update Details" : 'Add Child',
                func: () {
                  _addChild();
                },
              )
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
        ],
      ),
    );
  }

  _addChild() {
    // is form complete and is child registered with Oxford?
    if (_formKey.currentState!.validate()) {
      FireStoreCrud()
          .childNotRegisteredAlready(studyID: _trialIDcontroller.text).then((proceed) {

            if (!proceed) {
              print('child already registered');
              MySnackBar.error(
                  message:
                  "This child has already been registered.",
                  color: Colors.red,
                  context: context);

        } else {
              MySnackBar.error(
                  message:
                  "Checking child details are correct...",
                  color: Colors.blue,
                  context: context);


        checkChild(_trialIDcontroller.text).then((childExists) async {
          // child is study participant
          if (childExists) {
            // get child details from Oxford API
            var details = await getChildDetails(_trialIDcontroller.text);
            print('details in add child');
            print(details);


            ChildModel child = ChildModel(
                dob: DateFormat('yyyy-MM-dd').format(dateOfBirth),
                name: _namecontroller.text,
                supplementStartDate: details['suppStart'],
                dischargeDate: details['dischargeDate'],
                studyID: _trialIDcontroller.text,
                parentID: FirebaseAuth.instance.currentUser!.uid,
                id: '',
                recruitedAfterDischarge: details['recruitedAfterDischarge']);

            isEditMode
                ? showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    AlertDialog(
                      content: const Text(
                          "Thank you. Your child's details have been updated successfully."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            ChildModel updatedChild = ChildModel(
                                dob: DateFormat('yyyy-MM-dd').format(
                                    dateOfBirth),
                                name: _namecontroller.text,
                                dischargeDate: details['dischargeDate'],
                                studyID: _trialIDcontroller.text,
                                parentID:
                                FirebaseAuth.instance.currentUser!.uid,
                                id: widget.child!.id,
                                recruitedAfterDischarge:
                                details['recruitedAfterDischarge'],
                                supplementStartDate: details['suppStart']);
                            Navigator.pushNamed(context, childinfopage,
                                arguments: updatedChild);
                          },
                          child: const Text('OK'),
                        )
                      ],
                    ))
                : Navigator.pop(context);

            isEditMode
                ? FireStoreCrud().updateChild(
                name: _namecontroller.text,
                dischargeDate: details['dischargeDate'],
                docid: widget.child!.id,
                dob: DateFormat('yyyy-MM-dd').format(dateOfBirth),
                recruitedAfterDischarge:
                details['recruitedAfterDischarge'],
                supplementStartDate: details['suppStart'])
                : FireStoreCrud().addChild(child: child);

            showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    AlertDialog(
                      content: const Text(
                          "Thank you. Your child has been added."),
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
          } else {
            print('child does not exist in study');
            MySnackBar.error(
                message:
                "Problem with child's Study Number, please check the ID is correct and"
                    " try again",
                color: Colors.red,
                context: context);
          }
        });
        }

      });// child exists with Oxford
      } // validate
    }


  _showdatepickerdob() async {
    var selecteddate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    setState(() {
      selecteddate != null ? dateOfBirth = selecteddate : null;
    });
  }

  _showdatepickerdued() async {
    var selecteddate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    setState(() {
      selecteddate != null ? dueDate = selecteddate : null;
    });
  }

  _showdatepickerdd() async {
    var selecteddate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    setState(() {
      selecteddate != null ? dischargeDate = selecteddate : null;
    });
  }

  Widget _showRecruitmentOption() {
    if (!isEditMode) {
      return Column(children: [
        SizedBox(
          height: 3.h,
        ),
        Text(
          'Were you recruited to the study before hospital discharge?',
          style:
              Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
        ),
        SizedBox(
          height: 2.h,
        ),
        Center(
          child: ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [AppColours.light_blue],
              [AppColours.light_blue]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 0,
            totalSwitches: 2,
            labels: ['Yes', 'No'],
            radiusStyle: true,
            onToggle: (index) {
              // index 0 = recruited before discharge
              // index 1 = recruited after discharge
              if (index == 1) {
                recruitedAfterDischarge = true;
              } else {
                recruitedAfterDischarge = false;
              }
            },
          ),
        ),
      ]);
    } else {
      return Container();
    }
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
          isEditMode ? 'Edit Child Details' : 'Add a Child',
          style:
              Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
        ),
        const SizedBox()
      ],
    );
  }

  // returns false if the child has already been added to the Dolfin app
  Future<bool> childNotRegistered(childID) async {
    print('find out if child registered');

    return await FireStoreCrud()
        .childNotRegisteredAlready(studyID: childID);
  }

  // http request to check child's ID is valid
  Future<bool> checkChild(childCheck) async {

    try {

      // acquire jwt from NPEU
      await dotenv.load();
      var baseUrl = dotenv.get('NPEU_URL');
      var authUrl = 'https://' + baseUrl + '/identityauthority/connect/token';

      var body = {
        'client_id': dotenv.get('CLIENT_ID'),
        'client_secret': dotenv.get('CLIENT_SECRET'),
        'scope': dotenv.get('SCOPE'),
        'grant_type': dotenv.get('GRANT_TYPE')
      };

      var authResponse = await http.post(Uri.parse(authUrl), body: body);
      if (authResponse.statusCode != 200) {
        return false;
      } else {
        var jwt = jsonDecode(authResponse.body)['access_token'];

        // check if child and parent are valid
        var parentEmail = FirebaseAuth.instance.currentUser!.email;
        var queryParameters = {'Email': parentEmail};
        var childCheckUrl = Uri.https(baseUrl,
            '/dolfindata/api/participant/confirm/$childCheck', queryParameters);

        // returns true or false to indicate if child is part of study and matches
        // parent email
        final response = await http
            .get(childCheckUrl, headers: {'Authorization': 'Bearer $jwt'});
        if (response.statusCode == 200) {
          bool b = response.body.toLowerCase() == 'true';
          return b;
        } else {
          return false;
        }
      }
    } catch (err) {
      print(err);
      return false;
    }
  }


  // http request to get child's details
  getChildDetails(childID) async {
    try {

      // acquire jwt from NPEU
      await dotenv.load();
      var baseUrl = dotenv.get('NPEU_URL');
      var authUrl = 'https://' + baseUrl + '/identityauthority/connect/token';

      var body = {
        'client_id': dotenv.get('CLIENT_ID'),
        'client_secret': dotenv.get('CLIENT_SECRET'),
        'scope': dotenv.get('SCOPE'),
        'grant_type': dotenv.get('GRANT_TYPE')
      };

      var authResponse = await http.post(Uri.parse(authUrl), body: body);
        var token = jsonDecode(authResponse.body)['access_token'];

        var childDatesUrl = Uri.https(baseUrl,
            '/dolfindata/api/participant/dates/$childID');

        // returns dates as dictionary or 204 if child does not exist
        final response = await http
            .get(childDatesUrl, headers: {'Authorization': 'Bearer $token'});
        if (response.statusCode == 200) {
          var details = jsonDecode(response.body);
          var dischargeTimestamp = DateTime.parse(details['DISCHARGE_DATE']);
          var suppStartTimestamp = DateTime.parse(details['SUPPLEMENT_START_DATE']);
          var recruitedAfterD = true;
          // if supp start date is before discharge, recruited before discharge
          // is true, otherwise false
          if (dischargeTimestamp.isAfter(suppStartTimestamp)) {
            print('recruited before discharge');
            recruitedAfterD = false;
          }

          // convert timestamp to strings for Firestore
          var dischargeStr = DateFormat('yyyy-MM-dd').format(dischargeTimestamp);
          var suppStartStr = DateFormat('yyyy-MM-dd').format(suppStartTimestamp);

          var childDetails = {
            'dischargeDate': dischargeStr,
            'recruitedAfterDischarge': recruitedAfterD,
            'suppStart': suppStartStr
          };

          return childDetails;

        } else {
          // return false;
        }

    } catch (err) {
      print(err);
      return false;
    }
  }
}
