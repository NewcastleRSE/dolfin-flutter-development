import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/constants/consts_variables.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';

import '../../shared/services/notification_service.dart';
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
    dischargeDate = isEditMode
        ? DateTime.parse(widget.child!.dischargeDate)
        : DateTime.now();
    dueDate =
        isEditMode ? DateTime.parse(widget.child!.dueDate) : DateTime.now();
    recruitedAfterDischarge = false;

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
            'Trial ID',
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
            hint: "Trial ID",
            icon: Icons.title,
            showicon: false,
            validator: (value) {
              return value!.isEmpty
                  ? "Please Enter Your Child's Trial ID"
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
            'Due date',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: DateFormat('dd/MM/yyyy').format(dueDate),
            icon: Icons.calendar_today,
            readonly: true,
            showicon: false,
            validator: (value) {},
            ontap: () {
              _showdatepickerdued();
            },
            textEditingController: TextEditingController(),
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
              _showdatepickerdob();
            },
            textEditingController: TextEditingController(),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Discharge date',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: DateFormat('dd/MM/yyyy').format(dischargeDate),
            icon: Icons.calendar_today,
            readonly: true,
            showicon: false,
            validator: (value) {},
            ontap: () {
              _showdatepickerdd();
            },
            textEditingController: TextEditingController(),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Were you recruited to the study before hospital discharge?',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
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
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                color: isEditMode ? AppColours.green : AppColours.dark_blue,
                width: 40.w,
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
      checkChild(_trialIDcontroller.text).then((childExists) {
        // child is study participant
        if (childExists) {
          print('child is a study participant so save to DB');

          ChildModel child = ChildModel(
              name: _namecontroller.text,
              dob: DateFormat('yyyy-MM-dd').format(dateOfBirth),
              dischargeDate: DateFormat('yyyy-MM-dd').format(dischargeDate),
              dueDate: DateFormat('yyyy-MM-dd').format(dueDate),
              studyID: _trialIDcontroller.text,
              parentID: FirebaseAuth.instance.currentUser!.uid,
              id: '',
              recruitedAfterDischarge: recruitedAfterDischarge);

          isEditMode
              ? FireStoreCrud().updateChild(
                  docid: widget.child!.id,
                  name: _namecontroller.text,
                  dob: DateFormat('yyyy-MM-dd').format(dateOfBirth),
                )
              : FireStoreCrud().addChild(child: child);

          Navigator.pop(context);
        } else {
          print('child does not exist in study');
          MySnackBar.error(
              message: "Problem with child's trial ID, please check the ID is correct and"
                  " try again",
              color: Colors.red,
              context: context);
        }
      }); // child exists with Oxford
    } // validate
  }

  _showdatepickerdob() async {
    var selecteddate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    setState(() {
      selecteddate != null ? dischargeDate = selecteddate : null;
    });
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
          isEditMode ? 'Edit Child' : 'Add a Child',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox()
      ],
    );
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

      var authResponse = await http.post(
          Uri.parse(authUrl),
          body:body);
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
        final response = await http.get(childCheckUrl,
            headers: {'Authorization': 'Bearer $jwt'});
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
}
