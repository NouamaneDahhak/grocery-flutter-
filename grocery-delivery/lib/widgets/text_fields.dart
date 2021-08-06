import 'package:delivery/models/state_models/theme_model.dart';
import 'package:flutter/material.dart';

///All textFields used in the app
class TextFields {
  static Widget emailTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputAction textInputAction,
    required TextInputType textInputType,
    required String labelText,
    required IconData iconData,
    required Function onSubmitted,
    required bool error,
    required bool isLoading,
    required ThemeModel themeModel,
    bool obscureText = false,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: themeModel.secondBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
            width: 2, color: error ? Colors.red : Colors.transparent),
        /* boxShadow: [
            BoxShadow(
                blurRadius: 30,
                offset: Offset(0,5),
                color: themeModel.shadowColor
            )
          ]*/
      ),
      child: TextField(
        enabled: !isLoading,
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        onSubmitted: (value) {
          onSubmitted();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          labelText: labelText,
          icon: Icon(iconData),
        ),
      ),
    );
  }

  static Widget defaultTextField({
    required ThemeModel themeModel,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
    required String labelText,
    required Function(String)? onSubmitted,
    bool enabled = true,
    required bool error,
    required bool isLoading,
    Function(String)? onChanged,
    int minLines = 1,
    int? maxLines = 1,
    EdgeInsets padding = const EdgeInsets.all(10),
    EdgeInsets margin = const EdgeInsets.all(0),
    bool changeBackColor = false,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
  }) {
    Color backColor = (changeBackColor)
        ? themeModel.backgroundColor
        : themeModel.secondBackgroundColor;
    return Container(
      decoration: BoxDecoration(
        color: enabled ? backColor : backColor.withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
            width: 2, color: error ? Colors.red : Colors.transparent),
      ),
      padding: padding,
      margin: margin,
      child: TextField(
        obscureText: obscureText,
        maxLines: maxLines,
        minLines: minLines,
        enabled: enabled && !isLoading,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        controller: controller,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            labelText: labelText,
            contentPadding: EdgeInsets.only(left: 20, right: 20)),
      ),
    );
  }
}
