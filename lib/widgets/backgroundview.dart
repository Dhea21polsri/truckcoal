import 'package:flutter/cupertino.dart';

backgroundView1() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFFDEEDC), Color(0xFFD0F0F0), Color(0xFFD6F5D6)],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ),
  );
}

backgroundView2() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        const Color.fromARGB(128, 251, 253, 251), // Putih dengan 50% opacity
        const Color.fromARGB(128, 255, 194, 119), // Oranye dengan 50% opacity
        const Color.fromARGB(
          128,
          252,
          249,
          249,
        ), // Abu-abu terang (CECECE) // Putih di bawah
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.2, 0.3, 0.8], // Mengatur distribusi warna gradien
    ),
  );
}

backgroundView3() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(58, 255, 194, 99), // Kuning pucat
        const Color.fromARGB(258, 152, 249, 249), // Gradasi ke warna oranye
      ],
      stops: [0.1, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}
