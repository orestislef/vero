import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vero/enums.dart';

import '../communication/api.dart';
import '../communication/models/users.dart';
import 'all_users.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  User? _user;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserStatus? _userStatus;
  bool _isSaving = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? _buildSelectUser() : _buildEditUser();
  }

  Widget _buildSelectUser() {
    return AllUsers(onTap: (user) {
      setState(() {
        _user = user;
      });
    });
  }

  Widget _buildEditUser() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _user = null;
              });
            },
            child: const Text('Select other User'),
          ),
        ),
        _buildEdit(),
      ],
    );
  }

  Widget _buildEdit() {
    if (_usernameController.text.isEmpty) {
      _usernameController.text = _user!.username;
    }
    _userStatus ??= _user!.status;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 20),
          const Text('Status'),
          DropdownButton<UserStatus>(
            value: _userStatus,
            onChanged: (UserStatus? value) {
              setState(() {
                _userStatus = value;
              });
            },
            items: UserStatus.values
                .map<DropdownMenuItem<UserStatus>>((UserStatus value) {
              return DropdownMenuItem<UserStatus>(
                value: value,
                child: Text(UserStatusExtension.enumToString(value)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _isSaving
              ? const CircularProgressIndicator.adaptive()
              : ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                          _onClickedOnSave();
                        },
                  child: const Text('Save'),
                ),
        ],
      ),
    );
  }

  void _onClickedOnSave() {
    setState(() {
      _isSaving = true;
    });
    Api()
        .updateUser(
            id: _user!.id,
            username: _usernameController.text,
            status: _userStatus!.name)
        .then((value) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonDecode(value.body)['message']),
        ),
      );
    });
  }
}
