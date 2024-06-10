import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/enums/user_status.dart';

import '../communication/models/users.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key, this.onTap});

  final Function(User user)? onTap;

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Api().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
                SizedBox(height: 10),
                Text('Loading Users...'),
              ],
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var userResponse =
                UsersResponse.fromJson(jsonDecode(snapshot.data!.body));
            return userResponse.users.isEmpty
                ? const Center(child: Text('No users'))
                : Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userResponse.users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getColor(userResponse.users[index])),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  userResponse.users[index].id.toString(),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              )),
                          title: Text(userResponse.users[index].username),
                          subtitle: Text(userResponse.users[index].status.name),
                          onTap: () {
                            widget.onTap?.call(userResponse.users[index]);
                          },
                        );
                      },
                    ),
                  );
          } else {
            return const Center(child: Text('No data'));
          }
        });
  }

  Color _getColor(User user) {
    switch (user.status) {
      case UserStatus.admin:
        return Colors.green;
      case UserStatus.driver:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
