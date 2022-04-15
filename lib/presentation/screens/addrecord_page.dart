import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

enum SupplementOptions { fullDose, partialDose, noDose }

class AddRecordPage extends StatefulWidget {
  final ChildModel? child;
  final RecordModel? record;

  const AddRecordPage({
    this.child,
    this.record,
    Key? key,
  }) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  get isEditMode => widget.record != null;

  late TextEditingController _supplementcontroller;
  late TextEditingController _reasoncontroller;
  late TextEditingController _weightcontroller;
  late SupplementOptions? _supplement;

  late DateTime recordDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _weightcontroller =
        TextEditingController(text: isEditMode ? widget.record!.weight : '');
    _supplementcontroller = TextEditingController(
        text: isEditMode ? widget.record!.supplement : '');
    _reasoncontroller =
        TextEditingController(text: isEditMode ? widget.record!.reason : '');
    recordDate =
        isEditMode ? DateTime.parse(widget.record!.date) : DateTime.now();

    _supplement = SupplementOptions.fullDose;
  }

  @override
  void dispose() {
    super.dispose();
    _weightcontroller.dispose();
    _supplementcontroller.dispose();
    _reasoncontroller.dispose();
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
            'Date',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: DateFormat('dd/MM/yyyy').format(recordDate),
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
            height: 3.h,
          ),
          Text(
            'Supplement',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            'Have you given your baby their DOLFIN supplement today?',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text('Yes, all of it'),
                leading: Radio<SupplementOptions>(
                  value: SupplementOptions.fullDose,
                  groupValue: _supplement,
                  onChanged: (SupplementOptions? value) {
                    setState(() {
                      _supplement = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Yes, some of it'),
                leading: Radio<SupplementOptions>(
                  value: SupplementOptions.partialDose,
                  groupValue: _supplement,
                  onChanged: (SupplementOptions? value) {
                    setState(() {
                      _supplement = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('No'),
                leading: Radio<SupplementOptions>(
                  value: SupplementOptions.noDose,
                  groupValue: _supplement,
                  onChanged: (SupplementOptions? value) {
                    setState(() {
                      _supplement = value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Reason',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            'Thank you for letting us know. It would be helpful for us to know why:',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyStatefulWidget(),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            readonly: isEditMode ? true : false,
            hint: "Please give details",
            icon: Icons.title,
            showicon: false,
            validator: (value) {
              return value!.isEmpty ? "Please enter a reason" : null;
            },
            textEditingController: _reasoncontroller,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Weight',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: "Enter your child's weight",
            icon: Icons.title,
            showicon: false,
            validator: (value) {
              return value!.isEmpty
                  ? "Please Enter Your Child's First Name"
                  : null;
            },
            textEditingController: _weightcontroller,
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
                width: 45.w,
                title: isEditMode ? "Update Record" : 'Add Record',
                func: () {
                  _addRecord();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  _addRecord() {
    if (_formKey.currentState!.validate()) {
      RecordModel record = RecordModel(
        weight: _weightcontroller.text,
        date: DateFormat('yyyy-MM-dd').format(recordDate),
        supplement: _supplementcontroller.text,
        reason: _reasoncontroller.text,
        child: widget.child!.id,
        id: '',
      );
      isEditMode
          ? FireStoreCrud().updateRecord(
              docid: widget.record!.id,
              supplement: _supplementcontroller.text,
              weight: _weightcontroller.text,
            )
          : FireStoreCrud().addRecord(child: record);

      Navigator.pop(context);
    }
  }

  _showdatepicker() async {
    var selecteddate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    setState(() {
      selecteddate != null ? recordDate = selecteddate : null;
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
          isEditMode ? 'Edit Record' : 'Add a Record',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox()
      ],
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Text(
          'I Forgot',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
        ),
        Checkbox(
          checkColor: AppColours.dark_blue,
          activeColor: AppColours.white,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        )
      ]),
      Row(children: [
        Text(
          'We have run out',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
        ),
        Checkbox(
          checkColor: AppColours.dark_blue,
          activeColor: AppColours.white,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        )
      ]),
      Row(children: [
        Text(
          'My baby refused it',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
        ),
        Checkbox(
          checkColor: AppColours.dark_blue,
          activeColor: AppColours.white,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        )
      ]),
      Row(children: [
        Text(
          'My baby spat it out',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
        ),
        Checkbox(
          checkColor: AppColours.dark_blue,
          activeColor: AppColours.white,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        )
      ]),
      Row(children: [
        Text(
          'My baby is unwell',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
        ),
        Checkbox(
          checkColor: AppColours.dark_blue,
          activeColor: AppColours.white,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        )
      ]),
      Row(children: [
        Text(
          'Other',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
        ),
        Checkbox(
          checkColor: AppColours.dark_blue,
          activeColor: AppColours.white,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        )
      ])
    ]);
  }
}
