import 'package:flutter/material.dart';
import '../extentions/colors_extension.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.height,
    this.width,
    this.onTap,
    this.radios,
    this.textAlign,
    this.sufIcon,
    this.contentPadding,
    this.fontSized,
    this.keyboardType,
    this.readOnly,
    this.obSecure,
    this.onChanged,
    this.preIcon,
    this.validator,
    this.mainColor,
    this.hintStyle,
    this.filledColor,
    this.mnLine,
    this.mxLine,
    this.borderWidth,
    this.focusNode,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusOn,
  });

  final TextEditingController controller;
  final Widget? preIcon;
  final String hint;
  final ValueChanged<String>? onChanged;
  final Widget? sufIcon;
  final bool? obSecure;
  final bool? readOnly;
  final double? height;
  final double? width;
  final double? borderWidth;
  final double? radios;
  final double? fontSized;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final Color? mainColor;
  final TextStyle? hintStyle;
  final Function()? onTap;
  final Color? filledColor;
  final int? mnLine;
  final int? mxLine;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusOn;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obSecure ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      textInputAction: widget.focusOn != null ? TextInputAction.next : widget.textInputAction,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(widget.focusOn);
      },
      onEditingComplete: widget.onEditingComplete,
      focusNode: widget.focusNode,
      cursorColor: context.colorScheme.onSurface,
      style: textTheme.titleSmall?.copyWith(color: context.colorScheme.onSurface, fontSize: widget.fontSized),
      textAlignVertical: TextAlignVertical.center,
      textAlign: widget.textAlign ?? TextAlign.start,
      obscureText: _obscure,
      controller: widget.controller,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      minLines: widget.mnLine,
      maxLines: widget.mxLine,
      readOnly: widget.readOnly ?? false,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      validator: widget.validator,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.filledColor ?? context.primaryColor,
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintText: widget.hint,
        hintStyle:
            widget.hintStyle ??
            textTheme.titleSmall?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(130),
              fontSize: widget.fontSized ?? 14,
            ),
        labelStyle:
            widget.hintStyle ??
            textTheme.titleSmall?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(130),
              fontSize: widget.fontSized ?? 14,
            ),
        prefixIcon: widget.preIcon,
        suffixIcon: widget.obSecure == true
            ? InkWell(
                onTap: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
                child: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: context.colorScheme.onSurface.withAlpha(130),
                ),
              )
            : widget.sufIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radios ?? 8),
          borderSide: BorderSide(color: context.colorScheme.secondary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radios ?? 8),
          borderSide: BorderSide(color: widget.mainColor ?? context.colorScheme.secondary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radios ?? 8),
          borderSide: BorderSide(
            color: widget.mainColor ?? context.colorScheme.secondary,
            width: widget.borderWidth ?? 3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radios ?? 8),
          borderSide: BorderSide(color: context.colorScheme.error, width: 1),
        ),
        errorStyle: textTheme.labelSmall?.copyWith(color: context.colorScheme.error, height: 0.8),
      ),
    );
  }
}
