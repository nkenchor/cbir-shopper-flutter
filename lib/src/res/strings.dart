import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> alert(
  BuildContext context, {
  Widget? title,
  Widget? content,
  Widget? textOK,
}) =>
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: textOK ?? const Text('OK'),
          ),
        ],
      ),
    );
