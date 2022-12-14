import 'package:dio/dio.dart';
import 'package:evans/devices/device.dart';
import 'package:evans/notifications/notification.dart';
import 'package:evans/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:evans/services/local_notification_service.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Dio dio = Dio();
  late final LocalNotificationService service;

  bool isON = false;

  final CircularSliderAppearance appearance01 =
      const CircularSliderAppearance();

  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    Settings(),
    Devices(),
    Notifications(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// ignore: non_constant_identifier_names

  @override
  void initState() {
    var service = LocalNotificationService();
    service.intialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Appliance Control',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black),
            label: 'Settings',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: "Home",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            label: "Notifications",
            backgroundColor: Colors.white,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}
