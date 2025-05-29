import 'package:flutter/material.dart';
import 'package:truckcoal_app/petugas/history.dart';
import 'package:truckcoal_app/petugas/rekam.dart';
import 'package:truckcoal_app/supervisor/user.dart';
import 'package:truckcoal_app/supervisor/verifikasi.dart';
import 'package:truckcoal_app/views/home.dart';
import 'package:truckcoal_app/views/profile.dart';

class BottomNavBar extends StatefulWidget {
  final String role; // 'Petugas' atau 'Supervisor'

  const BottomNavBar({Key? key, required this.role}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> riwayatData =
      []; // Data riwayat akan disimpan di sini

  @override
  Widget build(BuildContext context) {
    // Halaman sesuai role
    final List<Widget> pages;
    if (widget.role == 'petugas') {
      pages = [Home(), History(), Rekam(), Profile()];
    } else {
      pages = [Home(), Verifikasi(), User(), Profile()];
    }

    // Menu bawah sesuai role
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
                icon: Icon(Icons.verified), // Ganti dengan asset jika ada
                label: 'Verification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group), // Ganti dengan asset jika ada
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
