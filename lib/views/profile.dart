import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truckcoal_app/login/login.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/profileview.dart';
import 'editprofile.dart';

class Profile extends StatefulWidget {
  final String username;

  const Profile({super.key, required this.username});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  /// Mengambil data user dari Firestore berdasarkan username
  Future<void> _fetchUserData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .where('username', isEqualTo: widget.username)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userData = snapshot.docs.first.data();
          isLoading = false;
        });
      } else {
        setState(() {
          userData = {};
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
        userData = {};
      });
    }
  }

  /// Fungsi untuk mengedit data profil
  Future<void> _editProfile() async {
    if (userData == null) return;

    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditProfile(
              name: userData!['name'] ?? '',
              role: userData!['role'] ?? '',
              nip: userData!['nip'] ?? '',
              phoneNumber: userData!['phoneNumber'] ?? '',
              email: userData!['email'] ?? '',
              address: userData!['address'] ?? '',
            ),
      ),
    );

    if (updatedData != null) {
      setState(() {
        userData = updatedData;
      });

      final snapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .where('username', isEqualTo: widget.username)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(snapshot.docs.first.id)
            .update(updatedData);
      }
    }
  }

  /// Fungsi logout user
  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Konfirmasi Logout"),
            content: const Text("Apakah Anda yakin ingin logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Tutup dialog
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  if (mounted) {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  }
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: applogoutView('Profil', () => logout(context)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null || userData!.isEmpty
              ? const Center(child: Text("Data user tidak ditemukan"))
              : Stack(
                children: [
                  Container(
                    decoration: backgroundView3(),
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                'assets/img/profil.png',
                                width: 180,
                                height: 180,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                userData!['name'] ?? '',
                                style: GoogleFonts.lexend(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                userData!['role'] ?? '',
                                style: GoogleFonts.lexend(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('NIP*'),
                        kolominputprofilView(userData!['nip'] ?? ''),
                        const SizedBox(height: 10),
                        _buildLabel('No Telp*'),
                        kolominputprofilView(userData!['phoneNumber'] ?? ''),
                        const SizedBox(height: 10),
                        _buildLabel('Email*'),
                        kolominputprofilView(userData!['email'] ?? ''),
                        const SizedBox(height: 20),
                        _buildLabel('Alamat*'),
                        const SizedBox(height: 10),
                        kolominputalamatView(userData!['address'] ?? ''),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _editProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD7F5BA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Edit',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  /// Widget teks label
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.lexend(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}
