import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/dashboardview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String bulanAkumulasi = '';
  int validasi = 0;
  int trukMasuk = 0;
  int trukKeluar = 0;
  double timbanganMasuk = 0.0; // Changed to double for summing coalWeight
  double timbanganKeluar = 0.0; // Changed to double for summing coalWeight

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  void fetchDashboardData() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final querySnapshot =
        await FirebaseFirestore.instance.collection('record').get();
    final records = querySnapshot.docs;

    int tempValidasi = 0;
    int tempMasuk = 0;
    int tempKeluar = 0;
    double tempTimbanganMasuk = 0.0; // Total coalWeight for retail status
    double tempTimbanganKeluar = 0.0; // Total coalWeight for pindah stok status

    for (var doc in records) {
      final data = doc.data() as Map<String, dynamic>;

      final createdAtRaw = data['createdAt'];
      DateTime? createdAt;

      if (createdAtRaw is Timestamp) {
        createdAt = createdAtRaw.toDate();
      } else if (createdAtRaw is String) {
        createdAt = DateTime.tryParse(createdAtRaw);
      }

      if (createdAt != null &&
          createdAt.isAfter(monthStart) &&
          createdAt.isBefore(monthEnd)) {
        if (data['isValidated'] == true) {
          tempValidasi++;
        }

        if ((data['masuk'] ?? '').toString().isNotEmpty) {
          tempMasuk++;
        }

        if ((data['keluar'] ?? '').toString().isNotEmpty) {
          tempKeluar++;
        }

        final status = (data['status'] ?? '').toString().toLowerCase();

        // Hitung total coalWeight berdasarkan status
        if (status == 'retail') {
          tempTimbanganMasuk += (data['coalWeight'] ?? 0.0);
        }

        if (status == 'pindah stok') {
          tempTimbanganKeluar += (data['coalWeight'] ?? 0.0);
        }
      }
    }

    setState(() {
  bulanAkumulasi = '${getMonth(now.month)} ${now.year}';
      validasi = tempValidasi;
      trukMasuk = tempMasuk;
      trukKeluar = tempKeluar;
      timbanganMasuk = tempTimbanganMasuk;
      timbanganKeluar = tempTimbanganKeluar;
    });
  }

  String getMonth(int month) {
    switch (month) {
      case 1:
        return 'JANUARI';
      case 2:
        return 'FEBRUARI';
      case 3:
        return 'MARET';
      case 4:
        return 'APRIL';
      case 5:
        return 'MEI';
      case 6:
        return 'JUNI';
      case 7:
        return 'JULI';
      case 8:
        return 'AGUSTUS';
      case 9:
        return 'SEPTEMBER';
      case 10:
        return 'OKTOBER';
      case 11:
        return 'NOVEMBER';
      case 12:
        return 'DESEMBER';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: backgroundView2(),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileView(),
              const SizedBox(height: 10),
              infoView(
                'AKUMULASI',
                const Color(0xFFE8D1CE),
                'assets/img/kalender.png',
                value: ' $bulanAkumulasi',
              ),
              const SizedBox(height: 5),
              infoView(
                'VALIDASI',
                const Color(0xFFA2CDE2),
                'assets/img/validasi.png',
                value: '$validasi',
              ),
              const SizedBox(height: 30),
              truckreportView(
                trukKeluar: trukKeluar.toString(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  timbanganView(
                    'TIMBANGAN MASUK',
                    'assets/img/masuk.png',
                    value: timbanganMasuk.toStringAsFixed(
                      2,
                    ), 
                  ),
                  timbanganView(
                    'TIMBANGAN KELUAR',
                    'assets/img/keluar.png',
                    value: timbanganKeluar.toStringAsFixed(
                      2,
                    ), 
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
