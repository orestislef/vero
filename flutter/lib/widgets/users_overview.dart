import 'package:flutter/material.dart';

import 'all_users.dart';
import 'edit_user.dart';

class UsersOverview extends StatefulWidget {
  const UsersOverview({super.key});

  @override
  State<UsersOverview> createState() => _UsersOverviewState();
}

class _UsersOverviewState extends State<UsersOverview> {
  int _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _currentIndex == -1
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = -1;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.adaptive.arrow_back_rounded),
                      const SizedBox(width: 10),
                      const Text('Back'),
                    ],
                  ),
                ),
              ),
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case -1:
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.view_agenda),
              title: const Text('View all Users'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit User'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        );
      case 0:
        return const AllUsers();
      case 1:
        return const EditUser();
      case 2:
        return const Text('Assign user to driver');
      default:
        return Container();
    }
  }
}
