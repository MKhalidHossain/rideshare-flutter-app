import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_colors.dart';

class OutlinedTextFieldforProfileWidget extends StatefulWidget {
  final TextEditingController controller;
  // final String name;
  final bool isLable;
  final String? lebel;
  final TextInputType textInputType;
  final bool isIconshow;

  const OutlinedTextFieldforProfileWidget({
    super.key,
    required this.controller,

    this.isLable = true,
    this.lebel,
    required this.textInputType,
    this.isIconshow = false,
  });

  @override
  State<OutlinedTextFieldforProfileWidget> createState() =>
      _OutlinedTextFieldforProfileWidgetState();
}

class _OutlinedTextFieldforProfileWidgetState
    extends State<OutlinedTextFieldforProfileWidget> {
  bool _obscureText = false;

  //final String textFieldHeaderName;
  @override
  Widget build(BuildContext context) {
    Color textColor = Color(0xff737373);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   textFieldHeaderName,
        //   textAlign: TextAlign.start,
        //   style: TextStyle(
        //     color: Colors.grey.shade500,
        //     fontSize: 13,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.textInputType,
            style: TextStyle(color: textColor),
            // obscureText: !_obscureText,
            decoration: InputDecoration(
              //labelText: isLable && lebel != null ? lebel : null,
              labelText: widget.lebel,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
              border: OutlineInputBorder(),
              suffixIcon:
                  widget.isIconshow
                      ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.edit : Icons.edit_off_sharp,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                      : null,

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.context(context).borderColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
