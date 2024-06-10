import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:vero/enums.dart';
import 'package:vero/widgets/overview.dart';
import 'package:vero/widgets/route_overview.dart';
import 'package:vero/widgets/truck_overview.dart';

import 'driver_overview.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.userStatus});

  final UserStatus userStatus;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Welcome ${UserStatusExtension.enumToString(widget.userStatus)}!'),
        ),
      );
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    switch (widget.userStatus) {
      case UserStatus.admin:
      case UserStatus.mod:
        return _buildAdminPanel();
      case UserStatus.driver:
        return _buildDriverPanel();
      default:
        return _buildDriverPanel();
    }
  }

  Widget _buildAdminPanel() {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDriverPanel() {
    return Scaffold(
      appBar: AppBar(
        title: Text(UserStatusExtension.enumToString(widget.userStatus)),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomNavigationBar(
        iconSize: 30.0,
        selectedColor: Colors.white,
        strokeColor: Colors.white,
        unSelectedColor: Colors.grey[600],
        backgroundColor: Colors.black,
        borderRadius: const Radius.circular(20.0),
        blurEffect: true,
        opacity: 0.8,
        elevation: 10.0,
        items: [
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.home_work_rounded,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.person_4_rounded,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.local_shipping),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.route_rounded),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        isFloating: true,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const Overview();
      case 1:
        return const DriverOverview();
      case 2:
        return const TruckOverview();
      case 3:
        return const RouteOverview();
      default:
        return Container();
    }
  }
}
