import 'package:flutter/material.dart';

class DefaultContainer extends StatelessWidget {
  const DefaultContainer({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xffF8B195).withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xffF8B195).withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
