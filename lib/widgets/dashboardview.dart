// Membuat Container untuk informasi AKUMULASI dan VALIDASI tanpa judul ganda
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

infoView(
  String label,
  Color backgroundColor,
  String imageAssetPath, {
  required String value,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
    width: double.infinity,
    height: 68,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(imageAssetPath, width: 24, height: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontFamily: GoogleFonts.lexend().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: GoogleFonts.lexend().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}

profileView() {
  return Container(
    width: double.infinity,
    height: 203,
    decoration: BoxDecoration(
      color: const Color(0xFF24685B),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selamat Datang di \nTruckCoal ',
                style: TextStyle(
                  fontFamily: GoogleFonts.lexend().fontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/img/dashboardpic.png'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Aplikasi digital pencatatan data keluar dan masuk truk dan data timbangan batu bara PT. Bukit Asam',
            style: TextStyle(
              fontFamily: GoogleFonts.lexend().fontFamily,
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

truckreportView({required String trukKeluar}) {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 5,
    child: Container(
      width: double.infinity,
      height: 108,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Image.asset('assets/img/truk.png', width: 82, height: 82),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "TRUK KELUAR\nDAN MASUK",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts.lexend().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$trukKeluar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

timbanganView(String title, String imageAssetPath, {required String value}) {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 5,
    child: Container(
      width: 165,
      height: 182,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageAssetPath, width: 40, height: 40),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: GoogleFonts.lexend().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
