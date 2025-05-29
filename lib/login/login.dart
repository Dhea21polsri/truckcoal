import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/inputview.dart';
import 'package:truckcoal_app/widgets/navigationview.dart';
import 'package:truckcoal_app/widgets/textview.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void loginUser(String username, String password, BuildContext context) async {
    try {
      // Query Firestore berdasarkan username dan password
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .where('username', isEqualTo: username)
              .where('password', isEqualTo: password)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Data ditemukan
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final String role = userData['role'];

        // Navigasi ke BottomNavBar sesuai role
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomNavBar(role: role)),
        );
      } else {
        // Username/password salah
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Username atau password salah')));
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan saat login')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundView1(),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              // key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textView(
                    EdgeInsets.zero,
                    'Selamat Datang',
                    TextAlign.left,
                    Colors.black,
                    FontWeight.bold,
                    16.0,
                  ),
                  const SizedBox(height: 12),
                  textView(
                    EdgeInsets.zero,
                    'Aplikasi Pencatatan Data keluar masuk Truk dan Timbangan Batubara',
                    TextAlign.left,
                    Colors.black,
                    FontWeight.w500,
                    14.0,
                  ),
                  const SizedBox(height: 50),
                  textView(
                    EdgeInsets.zero,
                    'MASUK AKUN',
                    TextAlign.left,
                    Colors.black,
                    FontWeight.bold,
                    15.0,
                  ),
                  const SizedBox(height: 10),

                  inputView('Username', usernameController),
                  const SizedBox(height: 20),
                  inputView('Password', passwordController, obscure: true),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDFFFBF),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        final username = usernameController.text.trim();
                        final password = passwordController.text.trim();

                        if (username.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Harap isi username dan password'),
                            ),
                          );
                          return;
                        }

                        loginUser(username, password, context);
                      },

                      child: textView(
                        EdgeInsets.zero,
                        'Masuk',
                        TextAlign.left,
                        Colors.black,
                        FontWeight.bold,
                        15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
