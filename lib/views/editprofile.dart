import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/profileview.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String role;
  final String nip;
  final String phoneNumber;
  final String email;
  final String address;

  const EditProfile({
    super.key,
    required this.name,
    required this.role,
    required this.nip,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController nipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    roleController.text = widget.role;
    nipController.text = widget.nip;
    phoneController.text = widget.phoneNumber;
    emailController.text = widget.email;
    addressController.text = widget.address;
  }

  Future<void> _updateUserData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .where('email', isEqualTo: emailController.text)
              .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;

        Map<String, dynamic> updatedData = {
          'name': nameController.text,
          'role': roleController.text,
          'nip': nipController.text,
          'phoneNumber': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
        };

        // Tambahkan password hanya jika diisi
        if (passwordController.text.isNotEmpty) {
          updatedData['password'] = passwordController.text;
        }

        await FirebaseFirestore.instance
            .collection('user')
            .doc(docId)
            .update(updatedData);

        Navigator.pop(context, updatedData);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User tidak ditemukan.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView('Edit Profil'),
      body: Stack(
        children: [
          // Background full screen
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: backgroundView3(),
          ),

          // Konten scrollable
          SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Edit dan Perbarui Data Anda',
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                inputeditprofilView("Masukkan NIP anda", nipController),
                const SizedBox(height: 15),
                inputeditprofilView("Masukkan No telp anda", phoneController),
                const SizedBox(height: 15),
                inputeditprofilView("Masukkan email anda", emailController),
                const SizedBox(height: 15),
                inputeditprofilView("Masukkan alamat anda", addressController),
                const SizedBox(height: 15),

                // 🔒 Password field
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Ganti Password (opsional)',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _updateUserData,
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
                        'Simpan',
                        style: TextStyle(
                          fontFamily: GoogleFonts.lexend().fontFamily,
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
}
