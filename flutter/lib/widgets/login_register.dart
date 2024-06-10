import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/widgets/home.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('Login/Register')),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _onClickedOnLogin();
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _onClickedOnRegister();
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  void _onClickedOnLogin() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    debugPrint(_usernameController.text);
    debugPrint(_passwordController.text);

    Api()
        .login(
            username: _usernameController.text,
            password: _passwordController.text)
        .then((value) {
      _checkLogin(value);
    });
  }

  void _onClickedOnRegister() {
    Api()
        .register(
            username: _usernameController.text,
            password: _passwordController.text)
        .then((value) {
      _checkLogin(value);
    });
  }

  void _checkLogin(Response value) {
    String status = jsonDecode(value.body)['status'].toString();
    String message = jsonDecode(value.body)['message'].toString();
    if (value.statusCode == 200 &&
        Api().token != null &&
        Api().token!.isNotEmpty &&
        status == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }
}
