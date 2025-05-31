import 'package:flutter/material.dart';
import 'package:truckcoal_app/petugas/history.dart';
import 'package:truckcoal_app/petugas/rekam.dart';
import 'package:truckcoal_app/supervisor/user.dart';
import 'package:truckcoal_app/supervisor/verifikasi.dart';
import 'package:truckcoal_app/views/home.dart';
import 'package:truckcoal_app/views/profile.dart';

class BottomNavBar extends StatefulWidget {
  final String role;
    final String username;

  const BottomNavBar({Key? key, required this.role, required this.username})
    : super(key: key);
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> riwayatData =
      []; 

  @override
  Widget build(BuildContext context) {
  
    final List<Widget> pages;
    if (widget.role == 'petugas') {
      pages = [Home(), History(), Rekam(), Profile(username: widget.username)];
    } else {
      pages = [Home(), Verifikasi(), User(), Profile(username: widget.username)];
    }

    final List<BottomNavigationBarItem> navItems =
        widget.role == 'petugas'
            ? [
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/img/navbarhome.png')),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/img/navbarhistory.png')),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/img/navbarrecord.png')),
                label: 'Record',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/img/navbarprofil.png')),
                label: 'Profile',
              ),
            ]
            : [
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/img/navbarhome.png')),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.verified), 
                label: 'Verification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'User',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/img/navbarprofil.png')),
                label: 'Profile',
              ),
            ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: navItems,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
