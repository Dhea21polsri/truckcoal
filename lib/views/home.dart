import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/dashboardview.dart'; // Pastikan ini mengimpor timbanganView
import 'dart:async';

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
  double timbanganMasuk = 0.0;
  double timbanganKeluar = 0.0;

  StreamSubscription? _recordSubscription;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    bulanAkumulasi = '${getMonth(now.month)} ${now.year}';
    _listenToDashboardData();
  }

  @override
  void dispose() {
    _recordSubscription?.cancel();
    super.dispose();
  }

  void _listenToDashboardData() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    _recordSubscription = FirebaseFirestore.instance
        .collection('record')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart),
        )
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(monthEnd))
        .snapshots()
        .listen(
          (querySnapshot) {
            _updateDashboardData(querySnapshot.docs);
          },
          onError: (error) {
            print("Error listening to records: $error");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal memuat data dashboard: $error')),
            );
          },
        );
  }

  void _updateDashboardData(List<QueryDocumentSnapshot> records) {
    int tempValidasi = 0;
    int tempTrukMasuk = 0;
    int tempTrukKeluar = 0;
    double tempTimbanganMasuk = 0.0;
    double tempTimbanganKeluar = 0.0;

    for (var doc in records) {
      final data = doc.data() as Map<String, dynamic>;

      if (data['proses'] == 'sudah diverifikasi') {
        tempValidasi++;
      }

      final status = (data['status'] ?? '').toString().toLowerCase();
      if (status == 'retail') {
        tempTrukMasuk++;
        tempTimbanganMasuk += (data['coalWeight'] as num?)?.toDouble() ?? 0.0;
      }

      if (status == 'pindah stok') {
        tempTrukKeluar++;
        tempTimbanganKeluar += (data['coalWeight'] as num?)?.toDouble() ?? 0.0;
      }
    }

    setState(() {
      validasi = tempValidasi;
      trukMasuk = tempTrukMasuk;
      trukKeluar = tempTrukKeluar;
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
              // Pastikan truckreportView menerima trukMasuk jika Anda ingin menampilkannya di sana
              truckreportView(
                trukMasuk: trukMasuk.toString(),
                trukKeluar: trukKeluar.toString(),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  timbanganView(
                    'TIMBANGAN MASUK',
                    'assets/img/masuk.png',
                    // MODIFIKASI: Tambahkan ' Kg' di sini
                    value: '${timbanganMasuk.toStringAsFixed(2)} Kg',
                  ),
                  timbanganView(
                    'TIMBANGAN KELUAR',
                    'assets/img/keluar.png',
                    // MODIFIKASI: Tambahkan ' Kg' di sini
                    value: '${timbanganKeluar.toStringAsFixed(2)} Kg',
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
