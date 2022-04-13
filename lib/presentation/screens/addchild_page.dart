import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/constants/consts_variables.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

import '../../shared/services/notification_service.dart';

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
                  ? "Please enter the your child's Trial ID"
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
            height: 2.h,
          ),
          Text(
            'Discharge Date',
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
              _showdatepicker();
            },
            textEditingController: TextEditingController(),
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 1.h,
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
          )
        ],
      ),
    );
  }

  _addChild() {
    if (_formKey.currentState!.validate()) {
      ChildModel child = ChildModel(
        name: _namecontroller.text,
        dob: DateFormat('yyyy-MM-dd').format(dateOfBirth),
        studyID: _trialIDcontroller.text,
        id: '',
      );
      isEditMode
          ? FireStoreCrud().updateChild(
              docid: widget.child!.id,
              name: _namecontroller.text,
              dob: DateFormat('yyyy-MM-dd').format(dateOfBirth),
            )
          : FireStoreCrud().addChild(child: child);

      Navigator.pop(context);
    }
  }

  _showdatepicker() async {
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
}
