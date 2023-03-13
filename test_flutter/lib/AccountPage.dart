import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final String phoneNumber;

  const AccountPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  late String _phoneNumber;

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _phoneNumber,
                decoration: const InputDecoration(
                  labelText: '휴대폰 번호',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '휴대폰 번호를 입력해주세요.';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return '숫자만 입력 가능합니다.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
// 서버에 _phoneNumber 값을 저장하는 코드
                    _showSnackBar('변경되었습니다.');
                  }
                },
                child: const Text('변경'),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('로그아웃'),
                onTap: () {
// 로그아웃 처리를 위한 코드
                  _showSnackBar('로그아웃 되었습니다.');
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('탈퇴하기'),
                onTap: () {
// 탈퇴 처리를 위한 코드
                  _showSnackBar('회원탈퇴 되었습니다.');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}