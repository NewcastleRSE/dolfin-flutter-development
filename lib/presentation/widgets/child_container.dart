import 'package:dolfin_flutter/shared/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChildContainer extends StatelessWidget {
  final String id;
  final String studyID;
  final String name;
  final String dob;

  const ChildContainer({
    Key? key,
    required this.id,
    required this.studyID,
    required this.name,
    required this.dob,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 10.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColours.light_blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
          ),
        ],
      ),
    );
  }
}
