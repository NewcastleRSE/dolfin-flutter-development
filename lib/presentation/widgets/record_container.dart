import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:dolfin_flutter/presentation/screens/addrecord_page.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class RecordContainer extends StatelessWidget {
  final RecordModel record;
  final ChildModel? child;
  final bool editable;

  const RecordContainer(
      {Key? key,
      required this.child,
      required this.record,
      required this.editable})
      : super(key: key);

  String supplementToString(SupplementOptions? options) {
    if (record.id == "0") {
      return "No Record";
    }
    switch (options) {
      case SupplementOptions.noDose:
        {
          return "Supplement: No";
        }
      default:
        {
          return "Supplement: Yes";
        }
    }
  }

  Color? getColour(SupplementOptions? options) {
    if (record.id == "0") {
      return AppColours.grey;
    }

    switch (options) {
      case SupplementOptions.fullDose:
        {
          return AppColours.green;
        }
      case SupplementOptions.partialDose:
        {
          return AppColours.yellow;
        }
      default:
        {
          return AppColours.red;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 16.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getColour(record.supplement),
      ),
      child: Column(
        children: [
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                DateFormat('yyyy-MM-dd').format(record.date),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
              ),
              Text(
                supplementToString(record.supplement),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
              ),
            ]),
            const Spacer(),
            getEditButton(context, record.date)
          ])
        ],
      ),
    );
  }

  getEditButton(BuildContext context, DateTime date) {
    if (editable && record.id != "0") {
      return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, addrecordpage,
                arguments: <String, dynamic>{"data": record, "date": date});
          },
          child: Icon(Icons.edit, color: Colors.white),
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(12),
              primary: AppColours.light_blue),
        )
      ]);
    } else if (record.id == "0") {
      return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, addrecordpage,
                arguments: <String, dynamic>{"data": child, "date": date});
          },
          child: Icon(Icons.add, color: Colors.white),
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(12),
              primary: AppColours.light_blue),
        )
      ]);
    } else
      return Column(children: []);
  }
}
