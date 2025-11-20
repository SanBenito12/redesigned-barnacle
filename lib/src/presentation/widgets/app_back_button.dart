import 'package:flutter/material.dart';

Widget? buildAppBackButton(BuildContext context, {Color? color}) {
  if (!Navigator.of(context).canPop()) return null;
  return IconButton(
    onPressed: () {
      Navigator.of(context).maybePop();
    },
    icon: Icon(
      Icons.arrow_back_ios,
      color: color ?? Colors.black,
    ),
  );
}
