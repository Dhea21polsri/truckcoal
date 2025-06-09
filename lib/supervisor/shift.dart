import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/rekamview.dart';

class ShiftForm extends StatefulWidget {
  const ShiftForm({super.key});

  @override
  _ShiftFormState createState() => _ShiftFormState();
}

class _ShiftFormState extends State<ShiftForm> {
  final petugas1Controller = TextEditingController();
  final nip1Controller = TextEditingController();
  final role1Controller = TextEditingController();

  final petugas2Controller = TextEditingController();
  final nip2Controller = TextEditingController();
  final role2Controller = TextEditingController();

  final petugas3Controller = TextEditingController();
  final nip3Controller = TextEditingController();
  final role3Controller = TextEditingController();

  final petugas4Controller = TextEditingController();
  final nip4Controller = TextEditingController();
  final role4Controller = TextEditingController();

  final petugas5Controller = TextEditingController();
  final nip5Controller = TextEditingController();
  final role5Controller = TextEditingController();

  final petugas6Controller = TextEditingController();
  final nip6Controller = TextEditingController();
  final role6Controller = TextEditingController();

  final petugas7Controller = TextEditingController();
  final nip7Controller = TextEditingController();
  final role7Controller = TextEditingController();

  final petugas8Controller = TextEditingController();
  final nip8Controller = TextEditingController();
  final role8Controller = TextEditingController();

  final petugas9Controller = TextEditingController();
  final nip9Controller = TextEditingController();
  final role9Controller = TextEditingController();

  String role = 'Petugas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView('Shift'),
      body: Stack(
        children: [
          Container(
            decoration: backgroundView3(),
            height: double.infinity,
            width: double.infinity,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textSection('Shift 1'),
                inputPetugas(
                  1,
                  petugas1Controller,
                  nip1Controller,
                  role1Controller,
                ),
                inputPetugas(
                  2,
                  petugas2Controller,
                  nip2Controller,
                  role2Controller,
                ),
                inputPetugas(
                  3,
                  petugas3Controller,
                  nip3Controller,
                  role3Controller,
                ),

                textSection('Shift 2'),
                inputPetugas(
                  4,
                  petugas4Controller,
                  nip4Controller,
                  role4Controller,
                ),
                inputPetugas(
                  5,
                  petugas5Controller,
                  nip5Controller,
                  role5Controller,
                ),
                inputPetugas(
                  6,
                  petugas6Controller,
                  nip6Controller,
                  role6Controller,
                ),

                textSection('Shift 3'),
                inputPetugas(
                  7,
                  petugas7Controller,
                  nip7Controller,
                  role7Controller,
                ),
                inputPetugas(
                  8,
                  petugas8Controller,
                  nip8Controller,
                  role8Controller,
                ),
                inputPetugas(
                  9,
                  petugas9Controller,
                  nip9Controller,
                  role9Controller,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    saveShiftData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDFFFBF),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lexend().fontFamily,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ), // Mengubah warna font menjadi putih
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textSection(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget inputPetugas(
    int petugasNumber,
    TextEditingController petugasController,
    TextEditingController nipController,
    TextEditingController roleController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelView('Nama Petugas $petugasNumber'),
        rekamView(controller: petugasController),
        labelView('NIP'),
        rekamView(controller: nipController),
        labelView('Jabatan'),
        dropdownVIew(
          value: roleController.text.isNotEmpty ? roleController.text : role,
          options: ['Petugas', 'Supervisor'],
          onChanged: (val) {
            setState(() {
              roleController.text = val!;
            });
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void saveShiftData() async {
    try {
      final List<Map<String, dynamic>> allPetugas = [
        {
          'controller': petugas1Controller,
          'nip': nip1Controller,
          'role': role1Controller,
          'shift': 1,
        },
        {
          'controller': petugas2Controller,
          'nip': nip2Controller,
          'role': role2Controller,
          'shift': 1,
        },
        {
          'controller': petugas3Controller,
          'nip': nip3Controller,
          'role': role3Controller,
          'shift': 1,
        },
        {
          'controller': petugas4Controller,
          'nip': nip4Controller,
          'role': role4Controller,
          'shift': 2,
        },
        {
          'controller': petugas5Controller,
          'nip': nip5Controller,
          'role': role5Controller,
          'shift': 2,
        },
        {
          'controller': petugas6Controller,
          'nip': nip6Controller,
          'role': role6Controller,
          'shift': 2,
        },
        {
          'controller': petugas7Controller,
          'nip': nip7Controller,
          'role': role7Controller,
          'shift': 3,
        },
        {
          'controller': petugas8Controller,
          'nip': nip8Controller,
          'role': role8Controller,
          'shift': 3,
        },
        {
          'controller': petugas9Controller,
          'nip': nip9Controller,
          'role': role9Controller,
          'shift': 3,
        },
      ];

      for (final petugas in allPetugas) {
        final nama = petugas['controller'].text.trim();
        final nip = petugas['nip'].text.trim();
        final role = petugas['role'].text.trim();
        final shift = petugas['shift'];

        if (nama.isNotEmpty) {
          await FirebaseFirestore.instance.collection('shifts').add({
            'namapetugas': nama,
            'nip': nip,
            'role': role,
            'shift': shift,
          });
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Data Shift Berhasil Disimpan!')));

      // Clear all controllers
      for (final petugas in allPetugas) {
        petugas['controller'].clear();
        petugas['nip'].clear();
        petugas['role'].clear();
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data shift.')));
    }
  }
}
