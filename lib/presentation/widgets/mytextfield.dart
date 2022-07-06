import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

class MyTextfield extends StatelessWidget {
  final IconData icon;
  final String hint;
  final FormFieldValidator<String> validator;
  final TextEditingController textEditingController;
  final TextInputType keyboardtype;
  final bool obscure;
  final bool readonly;
  final bool showicon;
  final int? maxlength;
  final TextCapitalization textCapitalization;
  final Function()? ontap;
  const MyTextfield(
      {Key? key,
      required this.hint,
      required this.icon,
      required this.validator,
      required this.textEditingController,
      this.obscure = false,
      this.readonly = false,
      this.showicon = true,
      this.ontap,
      this.keyboardtype = TextInputType.text,
      this.textCapitalization = TextCapitalization.sentences,
      this.maxlength = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: textCapitalization,
      maxLines: 1,
      maxLength: maxlength,
      readOnly: readonly,
      obscureText: obscure,
      keyboardType: keyboardtype,
      onTap: readonly ? ontap : null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 9.sp,
            color: AppColours.black,
          ),
      decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
                width: 0,
              )),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.3.h),
          hintStyle: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 9.sp,
                color: AppColours.dark_blue,
              ),
          prefixIcon: showicon
              ? Icon(
                  icon,
                  size: 22,
                  color: AppColours.dark_blue,
                )
              : null,
          suffixIcon: readonly
              ? Icon(
                  icon,
                  size: 22,
                  color: AppColours.dark_blue,
                )
              : null),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}
