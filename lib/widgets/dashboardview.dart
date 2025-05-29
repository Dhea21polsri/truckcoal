// Membuat Container untuk informasi AKUMULASI dan VALIDASI tanpa judul ganda
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

infoView(
  String text,
  // String title,
  Color backgroundColor,
  String imageAssetPath, // Menambahkan parameter untuk gambar
) {
  return Container(
    margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
    width: 380, // Menetapkan lebar container
    height: 68, // Menetapkan tinggi container
    decoration: BoxDecoration(
      color: backgroundColor, // Menggunakan warna yang dinamis
      borderRadius: BorderRadius.circular(10), // Sudut yang lebih halus
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0), // Memberikan jarak di sekitar teks
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Menyusun teks ke kiri dan kanan
        children: [
          Row(
            children: [
              // Menggunakan Image.asset untuk menggantikan Icon
              Image.asset(
                imageAssetPath, // Path gambar yang berbeda untuk setiap case
                width: 24, // Menetapkan lebar gambar
                height: 24, // Menetapkan tinggi gambar
              ),
              const SizedBox(
                width: 8,
              ), // Memberikan jarak antara gambar dan teks
              // Text(
              //   title, // Tampilkan hanya AKUMULASI atau VALIDASI tanpa duplikasi
              //   style: const TextStyle(
              //     fontFamily: GoogleFonts.lexend().fontFamily,
              //     fontSize: 18, // Ukuran font
              //     fontWeight: FontWeight.bold, // Ketebalan font
              //     color: Colors.black, // Warna teks
              //   ),
              // ),
            ],
          ),
          Text(
            text, // Tampilkan nilai yang sesuai (validasi atau bulan)
            style: TextStyle(
              fontFamily: GoogleFonts.lexend().fontFamily,
              fontSize: 18, // Ukuran font
              fontWeight: FontWeight.bold, // Ketebalan font
              color: Colors.black, // Warna teks
            ),
          ),
        ],
      ),
    ),
  );
}

// Membuat Container dengan teks dan profil
profileView() {
  return Container(
    width: double.infinity, // Menetapkan lebar container
    height: 203, // Menetapkan tinggi container
    decoration: BoxDecoration(
      color: const Color(0xFF24685B), // Hijau gelap
      borderRadius: BorderRadius.circular(15), // Sudut yang lebih halus
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris untuk menyambut pengguna dan menampilkan profil
          Row(
            children: [
              const SizedBox(
                width: 10,
              ), // Menambahkan jarak antara foto dan teks
              Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontFamily: GoogleFonts.lexend().fontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 30),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  'assets/img/dashboardpic.png',
                ), // Pastikan path benar
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

// Membuat Card untuk TRUK KELUAR DAN MASUK
truckreportView() {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Membuat sudut lebih halus
    ),
    elevation: 5, // Menambahkan bayangan
    child: Container(
      width: 380, // Menetapkan lebar container
      height: 108, // Menetapkan tinggi container
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/img/truk.png', // Ganti dengan path gambar Anda
              width: 102, // Menetapkan lebar gambar
              height: 82, // Menetapkan tinggi gambar
            ),
          ),
          // Menambahkan SizedBox untuk memberi jarak antara gambar dan teks
          const SizedBox(width: 50), // Memberikan jarak antara gambar dan teks
          // Kolom untuk teks bertingkat dan angka sejajar
          Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .center, // Menyusun teks dan angka secara vertikal
            mainAxisAlignment:
                MainAxisAlignment.center, // Menyusun secara vertikal di tengah
            children: [
              RichText(
                textAlign:
                    TextAlign.center, // Menambahkan textAlign untuk center
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "TRUK KELUAR\n", // Teks pertama dengan baris baru
                      style: TextStyle(
                        fontFamily: GoogleFonts.lexend().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "DAN MASUK", // Teks kedua
                      style: TextStyle(
                        fontFamily: GoogleFonts.lexend().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Menambahkan jarak lebih antara teks dan angka
              const SizedBox(height: 8), // Menambahkan jarak lebih
              // Text(
              //   trukMasuk, // Menampilkan data truk masuk
              //   style: const TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Membuat Card untuk TIMBANGAN MASUK DAN KELUAR (dalam bentuk persegi dengan ikon di atas dan teks di bawah)
timbanganView(String title, String imageAssetPath) {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Membuat sudut lebih halus
    ),
    elevation: 5, // Menambahkan bayangan
    child: Container(
      width: 165, // Menetapkan lebar container
      height: 182, // Tinggi agar persegi
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Tengah vertikal
        crossAxisAlignment: CrossAxisAlignment.center, // Tengah horizontal
        children: [
          Image.asset(
            imageAssetPath, // Ganti dengan path gambar yang sesuai
            width: 40, // Menetapkan lebar gambar
            height: 40, // Menetapkan tinggi gambar
          ),
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
          // Text(
          //   '$count',
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
        ],
      ),
    ),
  );
}
