import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:url_launcher/url_launcher.dart';

class AddRecordPage extends StatefulWidget {
  final ChildModel? child;
  final RecordModel? record;
  final DateTime? date;

  const AddRecordPage({
    this.child,
    this.record,
    this.date,
    Key? key,
  }) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  get isEditMode => widget.record != null;

  late String _childStudyID;

  late TextEditingController _reasoncontroller;

  late SupplementOptions? _supplement;
  late List _reasons;
  late bool reason0;
  late bool reason1;
  late bool reason2;
  late bool reason3;
  late bool reason4;
  late bool reason5;

  late DateTime recordDate;
  late bool _moreInfoVisible;
  late bool _otherReasonVisible;
  late bool _ranOutVisible;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _supplement =
        isEditMode ? widget.record!.supplement : SupplementOptions.fullDose;

    _reasons = isEditMode ? widget.record!.reasons : [];
    reason0 = isEditMode ? widget.record!.reasons.contains('I forgot') : false;
    reason1 =
        isEditMode ? widget.record!.reasons.contains('I have run out') : false;
    reason2 = isEditMode
        ? widget.record!.reasons.contains('My baby refused it')
        : false;
    reason3 = isEditMode
        ? widget.record!.reasons.contains('My baby spat it out')
        : false;
    reason4 = isEditMode
        ? widget.record!.reasons
            .contains('My baby was too unwell to take the supplement')
        : false;
    reason5 = isEditMode ? widget.record!.reasons.contains('Other') : false;

    _reasoncontroller = TextEditingController(
        text: isEditMode ? widget.record!.otherReason : '');

    recordDate = isEditMode ? widget.record!.date : widget.date!;

    _moreInfoVisible = (isEditMode &&
            (widget.record!.supplement == SupplementOptions.noDose ||
                widget.record!.supplement == SupplementOptions.partialDose))
        ? true
        : false;

    _otherReasonVisible = isEditMode ?  widget.record!.reasons.contains('Other') : false;

    _ranOutVisible = (isEditMode) ? true : false;

    _childStudyID = isEditMode ? widget.record!.studyID : widget.child!.studyID;
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
            'Thank you for taking part in the DOLFIN trial. It is important you give the DOLFIN supplement to your child every day, unless they are unable to take it because they are too unwell. Please use this form to let us know whether or not your baby has had their supplement today.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'If you have any questions or concerns about your baby or giving the supplement, please contact your local NHS clinical team using the contact details in your Parent Discharge Pack. If you are having trouble completing this form, please contact the research team on dolfin@npeu.ox.ac.uk / 01865 617919.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Date',
            style: Theme.of(context)
                .textTheme
                .displayLarge!
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
                .displayLarge!
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
                      _moreInfoVisible = false;

                      // Wipe the reasons list empty and uncheck all the boxes
                      _reasons.clear(); // clears the reasons list
                      // uncheck all the check boxes
                      reason0 = false;
                      reason1 = false;
                      reason2 = false;
                      reason3 = false;
                      reason4 = false;
                      reason5 = false;

                      // remove other box and other text
                      _otherReasonVisible = false;
                      _reasoncontroller.clear();
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
                      _moreInfoVisible = true;
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
                      _moreInfoVisible = true;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
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
                      leading: Checkbox(
                        value: reason0,
                        onChanged: (bool? value) {
                          setState(() {
                            reason0 = value!;
                            if (value == true) {
                              _reasons.add('I forgot');
                            } else {
                              _reasons.removeWhere(
                                  (element) => element == 'I forgot');
                            }
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('I have run out'),
                      leading: Checkbox(
                        value: reason1,
                        onChanged: (bool? value) {
                          setState(() {
                            reason1 = value!;
                            if (value == true) {
                              _reasons.add('I have run out');
                              _ranOutVisible = true;
                            } else {
                              _ranOutVisible = false;
                              _reasons.removeWhere(
                                  (element) => element == 'I have run out');
                            }
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('My baby refused it'),
                      leading: Checkbox(
                        value: reason2,
                        onChanged: (bool? value) {
                          setState(() {
                            reason2 = value!;
                            if (value == true) {
                              _reasons.add('My baby refused it');
                            } else {
                              _reasons.removeWhere(
                                  (element) => element == 'My baby refused it');
                            }
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('My baby spat it out'),
                      leading: Checkbox(
                        value: reason3,
                        onChanged: (bool? value) {
                          setState(() {
                            reason3 = value!;
                            if (value == true) {
                              _reasons.add('My baby spat it out');
                            } else {
                              _reasons.removeWhere((element) =>
                                  element == 'My baby spat it out');
                            }
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text(
                          'My baby was too unwell to take the supplement'),
                      leading: Checkbox(
                        value: reason4,
                        onChanged: (bool? value) {
                          setState(() {
                            reason4 = value!;
                            if (value == true) {
                              _reasons.add(
                                  'My baby was too unwell to take the supplement');
                            } else {
                              _reasons.removeWhere((element) =>
                                  element ==
                                  'My baby was too unwell to take the supplement');
                            }
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Other'),
                      leading: Checkbox(
                        value: reason5,
                        onChanged: (bool? value) {
                          setState(() {
                            reason5 = value!;
                            if (value == true) {
                              _reasons.add('Other');
                              _otherReasonVisible = true;
                            } else {
                              // delete text from text box
                              _reasoncontroller.clear();

                              _otherReasonVisible = false;
                              _reasons
                                  .removeWhere((element) => element == 'Other');
                            }
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
                Visibility(
                  visible: _ranOutVisible,
                  child: Text(
                    "If you have run out of supplement, please contact the research team at dolfin@npeu.ox.ac.uk / 01865 617919",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 14.sp, color: AppColours.red),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'The DOLFIN supplement dosing chart can be seen at ',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 14.sp),
                ),
                TextSpan(
                  text: 'https://www.npeu.ox.ac.uk/dolfin/parents/resources',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
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
                      .displayLarge!
                      .copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Thank you for completing this daily supplement check.",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
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
                  _addRecord();
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

  _addRecord() {
    if (_formKey.currentState!.validate()) {
      String thankYouText = isEditMode
          ? "Thank you for updating your baby's supplement data."
          : "Thank you for submitting your baby's supplement data.";

      RecordModel record = RecordModel(
        date: FireStoreCrud().setTimeToEarly(recordDate),
        dateSubmitted: FireStoreCrud().setTimeToEarly(DateTime.now()),
        supplement: _supplement,
        reasons: _reasons,
        otherReason: _reasoncontroller.text,
        child: isEditMode ? widget.record!.child : widget.child!.id,
        studyID: isEditMode ? widget.record!.studyID : widget.child!.studyID,
        id: '',
      );
      isEditMode
          ? FireStoreCrud().updateRecord(
              docid: widget.record!.id,
              supplement: _supplement.toString(),
              reasons: _reasons,
              otherReason: _reasoncontroller.text,
            )
          : FireStoreCrud().addRecord(record: record);

      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                content: Text(thankYouText),
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
          isEditMode ? 'Edit Record' : 'Daily Supplement Check',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontSize: 14.sp),
        ),
        const SizedBox()
      ],
    );
  }
}
