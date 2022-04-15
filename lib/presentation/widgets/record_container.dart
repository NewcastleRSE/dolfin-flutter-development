import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecordContainer extends StatelessWidget {
  final String id;
  final String date;
  final String supplement;
  final String weight;

  const RecordContainer({
    Key? key,
    required this.id,
    required this.date,
    required this.supplement,
    required this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 12.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: supplement == "Yes" ? AppColours.green : AppColours.red,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              date,
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              supplement,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              weight,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
            ),
          ])
        ],
      ),
    );
  }
}
