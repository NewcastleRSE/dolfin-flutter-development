import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:dolfin_flutter/presentation/screens/addrecord_page.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecordContainer extends StatelessWidget {
  final String id;
  final String date;
  final SupplementOptions? supplement;
  final num weight;

  const RecordContainer({
    Key? key,
    required this.id,
    required this.date,
    required this.supplement,
    required this.weight,
  }) : super(key: key);

  String supplementToString(SupplementOptions? options) {
    switch (options) {
      case SupplementOptions.noDose:
        {
          return "No";
        }
      default:
        {
          return "Yes";
        }
    }
  }

  Color? getColour(SupplementOptions? options) {
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
      height: 12.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getColour(supplement),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              Text(
                date,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
              ),
            ]),
            Column(children: [
              Text(
                supplementToString(supplement),
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
              ),
            ]),
            Column(children: [
              Text(
                weight.toStringAsFixed(1) + " kg",
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
              ),
            ])
          ])
        ],
      ),
    );
  }
}
