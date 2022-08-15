import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

class CustomDots extends StatelessWidget {
  final int myindex;
  const CustomDots({Key? key, required this.myindex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 19.w,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDot(0),
          _buildDot(1),
          _buildDot(2),
          _buildDot(3),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == myindex ? AppColours.white : Colors.white54),
    );
  }
}
