import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/tambahuserview.dart';

class TambahUser extends StatefulWidget {
  const TambahUser({super.key});

  @override
  State<TambahUser> createState() => _TambahUserState();
}

class _TambahUserState extends State<TambahUser> {
  final List<String> roles = ['petugas', 'supervisor']; // Daftar role

  TextEditingController nameController = TextEditingController();
  TextEditingController nipController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? selectedRole; // Menyimpan role yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView('Tambah User'),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: backgroundView3(),
        child: ListView(
          children: [
            labelView("Nama"),
            inputtambahuserView(nameController, hint: "Masukkan nama"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelView("NIP"),
                      inputtambahuserView(nipController, hint: "Masukkan NIP"),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelView("Jabatan"),
                      dropdownroleView(
                        roles: roles, // Mengirim roles yang tersedia
                        selectedRole:
                            selectedRole, // Mengirim role yang dipilih
                        onChanged: (newValue) {
                          setState(() {
                            selectedRole = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            labelView("Akun"),
            const SizedBox(height: 12),
            labelView("Username"),
            inputtambahuserView(
              usernameController,
              hint: "Masukkan username",
            ),
            const SizedBox(height: 16),
            labelView("Password"),
            inputtambahuserView(passwordController, obscure: true),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _simpanUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAEE89B),
                minimumSize: const Size(double.infinity, 50),
                elevation: 4,
                shadowColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child:Text(
                'Simpan',
                style: TextStyle(
                  fontFamily: GoogleFonts.lexend().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simpanUser() async {
    String name = nameController.text.trim();
    String nip = nipController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty ||
        nip.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua bagian wajib diisi.')));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('user').add({
        'name': name,
        'nip': nip,
        'username': username,
        'password': password,
        'role': selectedRole,
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User berhasil ditambahkan!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan user: $e')));
    }
  }
}
