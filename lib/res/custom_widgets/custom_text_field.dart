import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final bool isPassword;
  final String hint;
  final String? label;
  final Icon? prefix;
  final Widget? suffix;
  final bool isClickable;
  final int maxLines;
  final int? maxLength;
  final Color? filledColor;
  final Color? compColor;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? valueKey;
  final Function(String?)? onSubmit;
  final Function(String?)? onChange;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function()? suffixPressed;
  final String? Function(String?) validate;
  final TextStyle? style;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final double padding;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.type,
    required this.hint,
    this.label,
    this.prefix,
    this.suffix,
    this.isPassword = false,
    this.isClickable = true,
    this.maxLines = 1,
    this.maxLength,
    this.filledColor,
    this.compColor,
    this.focusNode,
    this.textInputAction,
    this.valueKey,
    this.onEditingComplete,
    this.suffixPressed,
    this.onSubmit,
    this.onChange,
    this.onTap,
    required this.validate,
    this.style,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.padding = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: TextFormField(
        key: ValueKey(valueKey),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        focusNode: focusNode,
        maxLines: maxLines,
        controller: controller,
        keyboardType: type,
        maxLength: maxLength,
        obscureText: isPassword,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        validator: validate,
        cursorColor: compColor,
        style: style,
        textAlign: textAlign,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          filled: true,
          fillColor: filledColor,
          focusColor: compColor,
          iconColor: compColor,
          hoverColor: compColor,
          prefixIcon: prefix,
          suffixIcon: suffix,
          //alignLabelWithHint: true,
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(color: compColor),
          hintStyle: TextStyle(
            color: compColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),

          /*enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),*/
          /*
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3, color: primaryColor),
          ),
*/
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 3,
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType type;
  final Function(String?)? onSubmit;
  final Function(String?)? onChange;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final String? Function(String?) validate;

  final bool isPassword;
  final String label;
  final bool isClickable;
  final int maxLines;
  final int? maxLength;
  final Color? filledColor;
  final Color? compColor;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  const PasswordTextField({
    super.key,
    required this.controller,
    this.type = TextInputType.visiblePassword,
    this.onSubmit,
    this.onChange,
    this.onTap,
    required this.validate,
    required this.label,
    this.isPassword = true,
    this.isClickable = true,
    this.maxLines = 1,
    this.maxLength,
    this.filledColor,
    this.compColor,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onEditingComplete,
        focusNode: widget.focusNode,
        maxLines: widget.maxLines,
        controller: widget.controller,
        keyboardType: widget.type,
        maxLength: widget.maxLength,
        obscureText: obscure,
        enabled: widget.isClickable,
        onFieldSubmitted: widget.onSubmit,
        onChanged: (value) => widget.onChange,
        onTap: () => widget.onTap,
        validator: widget.validate,
        cursorColor: widget.compColor,
        style: TextStyle(color: widget.compColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.filledColor,
          focusColor: widget.compColor,
          iconColor: widget.compColor,
          hoverColor: widget.compColor,
          alignLabelWithHint: true,
          labelText: widget.label,
          labelStyle: TextStyle(color: widget.compColor),
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),

          /*enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3, color: primaryColor),
          ),*/
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 3,
              color: Colors.redAccent,
            ),
          ),
          suffixIcon: Visibility(
            visible: widget.isPassword,
            child: IconButton(
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              },
              icon: obscure == false
                  ? Icon(
                      Icons.visibility,
                      color: widget.compColor,
                    )
                  : Icon(
                      Icons.visibility_off,
                      color: widget.compColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
