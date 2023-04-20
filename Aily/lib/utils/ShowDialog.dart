import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('로딩 중'),
        content: Row(
          children: const [
            CircularProgressIndicator(
              color: Color(0xFFF8B195),
            ),
            SizedBox(width: 20),
            Text('잠시만 기다려주세요...'),
          ],
        ),
      );
    },
  );
}

void showMsg(context, title, content){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
