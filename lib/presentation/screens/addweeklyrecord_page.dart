import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:dolfin_flutter/data/models/weeklyrecord_model.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:url_launcher/url_launcher.dart';

class AddWeeklyRecordPage extends StatefulWidget {
  final ChildModel? child;
  final WeeklyRecordModel? record;
  final DateTime? date;
  const AddWeeklyRecordPage({
    this.child,
    this.record,
    this.date,
    Key? key,
  }) : super(key: key);

  @override
  State<AddWeeklyRecordPage> createState() => _AddWeeklyRecordPageState();
}

class _AddWeeklyRecordPageState extends State<AddWeeklyRecordPage> {
  get isEditMode => widget.record != null;

  late String _childStudyID;

  late TextEditingController _reasoncontroller;

  late int? _numSupplements;
  late ReasonOptions? _reason;
  late bool? _problem;

  late DateTime recordDate;
  late bool _moreInfoVisible;
  late bool _otherReasonVisible;
  late bool _ranOutVisible;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _numSupplements = isEditMode ? widget.record!.numSupplements : 0;

    _reason = isEditMode ? widget.record!.reason : ReasonOptions.forgot;

    _reasoncontroller = TextEditingController(
        text: isEditMode ? widget.record!.otherReason : '');

    recordDate = isEditMode ? widget.record!.date : DateTime.now();

    _moreInfoVisible = (isEditMode &&
            widget.record!.numSupplements == SupplementOptions.noDose)
        ? true
        : false;

    _ranOutVisible =
        (isEditMode && widget.record!.reason == ReasonOptions.ranOut)
            ? true
            : false;

    _otherReasonVisible =
        (isEditMode && widget.record!.reason == ReasonOptions.other)
            ? true
            : false;

    _childStudyID = isEditMode ? widget.record!.studyID : widget.child!.studyID;

    _problem = isEditMode ? widget.record!.problem : false;
  }

  @override
  void dispose() {
    super.dispose();
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
            'Thank you for taking part in the DOLFIN trial. It is important you give the DOLFIN supplement to your child every day, unless they are unable to take it because they are too unwell.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Please use this form to let us know how much supplement your baby has had in the last seven days.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'If you have any questions or concerns about your baby or giving the supplement, please contact your local clinical team using the contact details in your Parent Discharge Pack. If you are having trouble completing this form, please contact the research team on dolfin@npeu.ox.ac.uk / 01865 617919.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Baby's Date of Birth",
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(widget.child!.dob)),
            icon: Icons.calendar_today,
            readonly: true,
            showicon: false,
            validator: (value) {},
            textEditingController: TextEditingController(),
            keyboardtype: TextInputType.none,
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
            'How many days did your baby have their DOLFIN supplement in the last seven days?',
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
                title: const Text('0 Days'),
                leading: Radio<int>(
                  value: 0,
                  groupValue: _numSupplements,
                  onChanged: (int? value) {
                    setState(() {
                      _numSupplements = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('1 Day'),
                leading: Radio<int>(
                  value: 1,
                  groupValue: _numSupplements,
                  onChanged: (int? value) {
                    setState(() {
                      _numSupplements = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('2 Days'),
                leading: Radio<int>(
                  value: 2,
                  groupValue: _numSupplements,
                  onChanged: (int? value) {
                    setState(() {
                      _numSupplements = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('3 Days'),
                leading: Radio<int>(
                  value: 3,
                  groupValue: _numSupplements,
                  onChanged: (int? value) {
                    setState(() {
                      _numSupplements = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('4 Days'),
                leading: Radio<int>(
                  value: 4,
                  groupValue: _numSupplements,
                  onChanged: (int? value) {
                    setState(() {
                      _numSupplements = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('5 Days'),
                leading: Radio<int>(
                  value: 5,
                  groupValue: _numSupplements,
                  onChanged: (int? value) {
                    setState(() {
                      _numSupplements = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('6 Days'),
                leading: Radio<int>(
                  value: 6,
                  groupValue: _numSupplements,
                  onChanged: (int? value) {
                    setState(() {
                      _numSupplements = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('7 Days'),
                leading: Radio<int>(
                  value: 7,
                  groupValue: _numSupplements,
                  onChanged: (int? value) {
                    setState(() {
                      _numSupplements = value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Were there any problems giving the DOLFIN supplement according to the instructions?',
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
                title: const Text('Yes'),
                leading: Radio<bool>(
                  value: true,
                  groupValue: _problem,
                  onChanged: (bool? value) {
                    setState(() {
                      _problem = value;
                      _moreInfoVisible = true;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('No'),
                leading: Radio<bool>(
                  value: false,
                  groupValue: _problem,
                  onChanged: (bool? value) {
                    setState(() {
                      _problem = value;
                      _moreInfoVisible = false;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Visibility(
            visible: _moreInfoVisible,
            child: Column(
              children: [
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
                Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('I forgot'),
                      leading: Radio<ReasonOptions>(
                        value: ReasonOptions.forgot,
                        groupValue: _reason,
                        onChanged: (ReasonOptions? value) {
                          setState(() {
                            _reason = value;
                            _otherReasonVisible = false;
                            _ranOutVisible = false;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('I have run out'),
                      leading: Radio<ReasonOptions>(
                        value: ReasonOptions.ranOut,
                        groupValue: _reason,
                        onChanged: (ReasonOptions? value) {
                          setState(() {
                            _reason = value;
                            _otherReasonVisible = false;
                            _ranOutVisible = true;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('My baby refused it'),
                      leading: Radio<ReasonOptions>(
                        value: ReasonOptions.refused,
                        groupValue: _reason,
                        onChanged: (ReasonOptions? value) {
                          setState(() {
                            _reason = value;
                            _otherReasonVisible = false;
                            _ranOutVisible = false;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('My baby spat it out'),
                      leading: Radio<ReasonOptions>(
                        value: ReasonOptions.spatOut,
                        groupValue: _reason,
                        onChanged: (ReasonOptions? value) {
                          setState(() {
                            _reason = value;
                            _otherReasonVisible = false;
                            _ranOutVisible = false;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('My baby was too unwell to take the supplement'),
                      leading: Radio<ReasonOptions>(
                        value: ReasonOptions.unwell,
                        groupValue: _reason,
                        onChanged: (ReasonOptions? value) {
                          setState(() {
                            _reason = value;
                            _otherReasonVisible = false;
                            _ranOutVisible = false;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Other'),
                      leading: Radio<ReasonOptions>(
                        value: ReasonOptions.other,
                        groupValue: _reason,
                        onChanged: (ReasonOptions? value) {
                          setState(() {
                            _reason = value;
                            _otherReasonVisible = true;
                            _ranOutVisible = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: _ranOutVisible || _otherReasonVisible,
                  child: SizedBox(
                    height: 2.h,
                  ),
                ),
                Visibility(
                  visible: _ranOutVisible,
                  child: Text(
                    "If you have run out of supplement, please contact the research team at dolfin@npeu.ox.ac.uk / 01865 617919",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 14.sp, color: AppColours.red),
                  ),
                ),
                Visibility(
                  visible: _otherReasonVisible,
                  child: MyTextfield(
                    readonly: false,
                    hint: "Please give details",
                    icon: Icons.title,
                    showicon: false,
                    validator: (value) {
                      return null;
                    },
                    textEditingController: _reasoncontroller,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'The DOLFIN supplement dosing chart can be seen at ',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 14.sp),
                ),
                TextSpan(
                  text: 'https://www.npeu.ox.ac.uk/dolfin/parents/resources',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 14.sp, color: AppColours.light_blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(
                          'https://www.npeu.ox.ac.uk/dolfin/parents/resources');
                    },
                ),
                TextSpan(
                  text: ' and is also included in your Parent Discharge Pack.',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Thank you for completing this weekly supplement check. Don’t forget to complete the form again on the same day next week; we will send you a reminder to do this.",
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                color: isEditMode ? AppColours.green : AppColours.dark_blue,
                width: 45.w,
                title: isEditMode ? "Update Record" : 'Add Record',
                func: () {
                  _addWeeklyRecord();
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

  _addWeeklyRecord() {
    if (_formKey.currentState!.validate()) {
      WeeklyRecordModel record = WeeklyRecordModel(
        date: recordDate,
        numSupplements: _numSupplements,
        reason: _reason,
        otherReason: _reasoncontroller.text,
        child: isEditMode ? widget.record!.child : widget.child!.id,
        studyID: isEditMode ? widget.record!.studyID : widget.child!.studyID,
        problem: _problem,
        id: '',
      );
      isEditMode
          ? FireStoreCrud().updateRecord(
              docid: widget.record!.id,
              supplement: _numSupplements.toString(),
              reason: _reason.toString(),
              otherReason: _reasoncontroller.text,
            )
          : FireStoreCrud().addWeeklyRecord(record: record);

      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                content: const Text(
                    "Thank you. Your baby's supplement information has been submitted successfully."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, homepage);
                    },
                    child: const Text('OK'),
                  )
                ],
              ));
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
          isEditMode ? 'Edit Record' : 'Weekly Supplement Check',
          style:
              Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
        ),
        const SizedBox()
      ],
    );
  }
}
