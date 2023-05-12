import 'package:flutter/material.dart';

class dictionaryScreen extends StatefulWidget {
  const dictionaryScreen({Key? key}) : super(key: key);

  @override
  _dictionaryScreenState createState() => _dictionaryScreenState();
}

class _dictionaryScreenState extends State<dictionaryScreen> {
  Color myColor = const Color(0xFFF8B195);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DictionaryWidget(context),
    );
  }

  Widget DictionaryWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            const SizedBox(height: 55),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('dictionary Page'),
                )
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}