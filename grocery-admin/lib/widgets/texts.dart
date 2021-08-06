import 'package:flutter/material.dart';

class Texts {
  static Text headline1(String text, Color color,
      {TextAlign alignment = TextAlign.left}) {
    return Text(
      text,
      textAlign: alignment,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 34,
          color: color),
    );
  }

  static Text headline2(String text, Color color,
      {TextAlign alignment = TextAlign.left}) {
    return Text(
      text,
      textAlign: alignment,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 24,
          color: color),
    );
  }

  static Text headline3(String text, Color color,
      {TextAlign alignment = TextAlign.left,
      TextDecoration decoration = TextDecoration.none}) {
    return Text(
      text,
      maxLines: 10,
      textAlign: alignment,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: decoration,
          decorationThickness: 5,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: color),
    );
  }

  static Text subheads(String text, Color color,
      {TextAlign alignment = TextAlign.left}) {
    return Text(
      text,
      textAlign: alignment,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: color),
    );
  }

  static Text text(String text, Color color,
      {int maxLines = 1000,
      TextAlign alignment = TextAlign.left,
      TextOverflow textOverflow = TextOverflow.visible,

      }) {
    return Text(
      text,
      softWrap: true,
      overflow: textOverflow,
      maxLines: maxLines,
      textAlign: alignment,
      style: TextStyle(
          height: 1.1,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: color),
    );
  }

  static Text descriptiveItems(String text, Color color,
      {TextAlign alignment = TextAlign.left,
      TextDecoration decoration = TextDecoration.none,
        int maxLines = 1000,
        TextOverflow textOverflow = TextOverflow.visible
      }) {
    return Text(
      text,
      textAlign: alignment,
      overflow: textOverflow,
      maxLines: maxLines,
      style: TextStyle(

          decoration: decoration,
          decorationThickness: 5,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: color),
    );
  }

  static Text descriptionText(String text, Color color,
      {TextAlign alignment = TextAlign.left, }) {
    return Text(
      text,
      textAlign: alignment,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: color),
    );
  }

  static Text helperText(String text, Color color,
      {TextAlign alignment = TextAlign.left}) {
    return Text(
      text,
      textAlign: alignment,
      maxLines: 5,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 11,
          color: color),
    );
  }
}
