import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/weight_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/data/repositories/firestore_crud.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/mytextfield.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:url_launcher/url_launcher.dart';

class AddWeightPage extends StatefulWidget {
  final ChildModel? child;
  final DateTime? date;

  const AddWeightPage({
    this.child,
    this.date,
    Key? key,
  }) : super(key: key);

  @override
  State<AddWeightPage> createState() => _AddWeightPageState();
}

class _AddWeightPageState extends State<AddWeightPage> {
  late String _childStudyID;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _weightcontroller;
  late DateTime recordDate;
  late String _dropdownvalue;

  @override
  void initState() {
    super.initState();

    _weightcontroller = TextEditingController(text: '');
    recordDate = DateTime.now();

    _childStudyID = widget.child!.studyID;

    _dropdownvalue = "1";
  }

  @override
  void dispose() {
    super.dispose();
    _weightcontroller.dispose();
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
            "We would like you to let us know your baby's weight once a month. Do you have a recent weight for your baby that you would like to let us know about?",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 3.h,
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
          Text(
            "Please enter the weight here in kilograms. For instance, if your baby weighs 4186 grams, please enter 4.186 kilograms.",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 2.h,
          ),
          MyTextfield(
            hint: "Enter your child's weight in (in kg)",
            keyboardtype: TextInputType.numberWithOptions(decimal: true),
            icon: Icons.title,
            showicon: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Your Child's Weight";
              } else if (int.parse(value) > 15) {
                return "Please check you have entered the correct weight in kg";
              }
              return null;
            },
            textEditingController: _weightcontroller,
          ),
          SizedBox(
            height: 4.h,
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
          Text(
            'When was this measurement recorded?',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 2.h,
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
            height: 4.h,
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
            'How many scoops of supplement per day are you giving your baby at the moment?',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please select a value:",
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 14.sp),
              ),
              SizedBox(
                width: 6.h,
              ),
              DropdownButton<String>(
                value: _dropdownvalue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownvalue = newValue!;
                  });
                },
                items: <String>[
                  '0',
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10',
                  '11',
                  '12'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            "Getting low on supplement? If you have less than 30 sachets of supplement left, please contact the research team on dolfin@npeu.ox.ac.uk / 01865 617919",
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 4.h,
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
                  text: '[URL]',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 14.sp, color: AppColours.light_blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(
                          'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
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
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                color: AppColours.dark_blue,
                width: 35.w,
                title: 'Submit',
                func: () {
                  _addWeight();
                },
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }

  _addWeight() {
    if (_formKey.currentState!.validate()) {
      WeightModel record = WeightModel(
        date: recordDate,
        weight: _weightcontroller.text,
        child: widget.child!.id,
        studyID: widget.child!.studyID,
        numScoops: _dropdownvalue,
        id: '',
      );
      FireStoreCrud().addWeight(record: record);

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
          'Baby Weight Check',
          style:
              Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
        ),
        const SizedBox()
      ],
    );
  }
}
