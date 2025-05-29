import 'package:flutter/material.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/dashboardview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // Mendapatkan tanggal dan waktu saat ini
    getMonth(
      now.month,
    ); // Mendapatkan nama bulan berdasarkan nomor bulan
    now.year.toString(); // Mendapatkan tahun saat ini

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: backgroundView2(),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container dengan teks dan profil
              profileView(),

              const SizedBox(height: 10),

              // Container untuk AKUMULASI
              infoView(
                'AKUMULASI',
                const Color(0xFFE8D1CE), // Warna latar belakang AKUMULASI
                'assets/img/kalender.png', // Path gambar untuk ikon
              ),

              const SizedBox(height: 5),

              // Container untuk VALIDASI
              infoView(
                'VALIDASI',
                const Color(0xFFA2CDE2), // Warna latar belakang VALIDASI
                'assets/img/validasi.png', // Path gambar untuk ikon
              ),

              const SizedBox(height: 30),

              // Kartu Data pertama (TRUK KELUAR DAN MASUK)
              truckreportView(),

              const SizedBox(height: 20),

              // Container untuk Timbangan masuk dan keluar (dalam satu baris dan berbentuk persegi)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timbangan Masuk
                  timbanganView(
                    'TIMBANGAN MASUK',
                    'assets/img/masuk.png', // Path gambar untuk Timbangan Masuk
                  ),

                  // Timbangan Keluar
                  timbanganView(
                    'TIMBANGAN KELUAR',
                    'assets/img/keluar.png', // Path gambar untuk Timbangan Keluar
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk mengubah angka bulan menjadi nama bulan
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
}
