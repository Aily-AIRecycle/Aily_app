import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text('로딩 중'),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(
              color: Color(0xFFF8B195),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                '잠시만 기다려주세요...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
            child: const Text('확인', style: TextStyle(color: Color(0xFFF8B195), fontSize: 17)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
