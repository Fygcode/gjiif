import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/res/colors.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final bool autofocus;
  final Color cursorColor;
  final double cursorWidth;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final int? maxLength;
  final int maxLines;
  final int minLines;
  final String? hintText;
  final String? labelText;
  final bool isRequired;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool isPasswordField;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? errorTextColor;


  CommonTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.autofocus = false,
    this.cursorColor = AppColor.primary,
    this.cursorWidth = 1.5,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.hintText,
    this.labelText,
    this.isRequired = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.isPasswordField = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.errorTextColor,

  }) : inputFormatters = [
         FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
         FilteringTextInputFormatter.deny(RegExp("^[\\ ]{0,1}")),
       ];

  // Named constructor for email
  CommonTextField.email({
    super.key,
    required this.controller,
    required this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.autofocus = false,
    this.cursorColor = AppColor.primary,
    this.cursorWidth = 1.5,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.isRequired = false,
    this.hintText = 'Enter your email',
    this.labelText,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.errorTextColor,


  }) : obscureText = false,
       keyboardType = TextInputType.emailAddress,
       textCapitalization = TextCapitalization.none,
       isPasswordField = false,
       inputFormatters = [
         FilteringTextInputFormatter.deny(RegExp(r'\s')),
         // No spaces allowed
         FilteringTextInputFormatter.allow(RegExp(r'^[\w.@]+$')),
         // Allow letters, numbers, dot, and @
       ];

  // Named constructor for password
  CommonTextField.password({
    super.key,
    required this.controller,
    required this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.autofocus = false,
    this.cursorColor = AppColor.primary,
    this.cursorWidth = 1.5,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.isRequired = false,
    this.hintText = 'Enter your password',
    this.labelText = 'Password',
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.errorTextColor,


  }) : obscureText = true,
       keyboardType = TextInputType.number,
       // Number pad only
       //     keyboardType = TextInputType.visiblePassword,
       textCapitalization = TextCapitalization.none,
       isPasswordField = true,
       inputFormatters = [
         FilteringTextInputFormatter.deny(RegExp(r'\s')), // No spaces allowed
       ];

  // Named constructor for phone number
  CommonTextField.phone({
    super.key,
    required this.controller,
    required this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.autofocus = false,
    this.cursorColor = AppColor.primary,
    this.cursorWidth = 1.5,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.isRequired = false,
    this.hintText,
    this.labelText,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.errorTextColor,


  }) : obscureText = false,
       keyboardType = TextInputType.phone,
       textCapitalization = TextCapitalization.none,
       isPasswordField = false,
       inputFormatters = [
         FilteringTextInputFormatter.digitsOnly,
         // Only digits allowed
         LengthLimitingTextInputFormatter(10),
         // Limit length to 10 digits (adjust as needed)
       ];

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.isPasswordField && !isVisible,
      textInputAction: widget.textInputAction,
      textAlign: widget.textAlign,
      style: widget.textStyle ?? defaultTextStyle,
      autofocus: widget.autofocus,
      cursorColor: widget.cursorColor,
      cursorWidth: widget.cursorWidth,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hintText ?? "",
        fillColor: widget.fillColor ?? (widget.enabled ? AppColor.white : Colors.grey.shade200),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColor.background,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColor.divider,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: widget.focusedBorderColor ?? AppColor.primary,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: widget.errorBorderColor ?? Colors.red,
            width: 1,
          ),
        ),

        errorStyle: TextStyle(
          color: widget.errorTextColor ?? Colors.red,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),

      //  labelText: widget.isRequired ? '${widget.labelText ?? ''} *' : widget.labelText,
        labelText: (widget.labelText != null && widget.labelText!.isNotEmpty)
            ? (widget.isRequired ? '${widget.labelText!} *' : widget.labelText)
            : null,

        labelStyle: TextStyle(color: Colors.black45),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.isPasswordField
                ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                )
                : widget.suffixIcon,
      ),
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
    );
  }

  TextStyle defaultTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 15,
  );
}
