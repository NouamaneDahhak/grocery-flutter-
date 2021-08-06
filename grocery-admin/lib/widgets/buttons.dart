import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///All buttons used in the app
class Buttons {
  static Widget socialButton({
    required String path,
    required Color color,
    required void Function() onPressed,
  }) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 1.0,
      fillColor: color,
      child: SvgPicture.asset(
        path,
        height: 20,
      ),
      padding: EdgeInsets.all(20.0),
      shape: CircleBorder(),
    );
  }

  static Widget button({
    required Widget widget,
    required void Function() onPressed,
    required Color color,
    bool border = false,
    EdgeInsets margin = const EdgeInsets.only(top: 20),
  }) {
    return Padding(
      padding: margin,
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: widget,
        ),
        style: TextButton.styleFrom(

            backgroundColor: (border == true) ? Colors.transparent : color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: (border == true)
                  ? BorderSide(color: color, width: 2)
                  : BorderSide.none,
            )),
      ),
    );
  }
}
