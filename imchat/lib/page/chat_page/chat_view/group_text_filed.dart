import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupTextFiled extends StatefulWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final double? height;
  final int? maxLines;
  final int? maxLength;
  final Alignment? alignment;
  final EdgeInsets? padding;
  final double? radius;
  final Color? bgColor;
  final bool autoFocus;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final TextStyle? placeholderTextStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  const GroupTextFiled({
    super.key,
    this.controller,
    this.placeholder,
    this.height,
    this.maxLines,
    this.maxLength,
    this.alignment,
    this.padding,
    this.radius,
    this.bgColor,
    this.autoFocus = false,
    this.onSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.focusNode,
    this.textStyle,
    this.placeholderTextStyle,
    this.inputFormatters,
    this.enabled,
  });

  @override
  State<StatefulWidget> createState() {
    return _GroupTextFiledState();
  }
}

class _GroupTextFiledState extends State<GroupTextFiled> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 40,
      padding: widget.padding ?? const EdgeInsets.fromLTRB(12, 0, 10, 0),
      alignment: widget.alignment ?? Alignment.centerLeft,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(widget.radius ?? 0),
      ),
      child: TextField(
        cursorColor: Colors.blue,
        autofocus: widget.autoFocus,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: widget.textStyle ?? const TextStyle(
          color: Color(0xff353535),
          fontSize: 14,
        ),
        controller: widget.controller,
        inputFormatters: widget.inputFormatters,
//         inputFormatters: [
// // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
//       //    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),//数字包括小数
//         ],
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        onSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          border: InputBorder.none,
          labelText: "",
          counterText: "",
          isDense: true,
          isCollapsed: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: widget.placeholderTextStyle ?? const TextStyle(
            color: Color(0xff999999),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
