import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';

class OutlinedTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final bool isLable;
  // final String? lebel;
  final TextInputType textInputType;
  final String textFieldHeaderName;
  final bool isObsecure;

  const OutlinedTextFieldWidget({
    super.key,
    required this.controller,
    required this.name,
    this.isLable = false,
    // this.lebel,
    required this.textInputType,
    required this.textFieldHeaderName,
    this.isObsecure = false,
  });

  @override
  State<OutlinedTextFieldWidget> createState() =>
      _OutlinedTextFieldWidgetState();
}

class _OutlinedTextFieldWidgetState extends State<OutlinedTextFieldWidget> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.textFieldHeaderName,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 40,
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.textInputType,
            style: TextStyle(color: AppColors.context(context).textColor),
            obscureText: _obscureText,
            decoration: InputDecoration(
              // labelText: isLable && lebel != null ? lebel : null,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),

              //labelText: lebel,
              labelStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
              suffixIcon:
                  widget.isObsecure
                      ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                      : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500, width: 2.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
