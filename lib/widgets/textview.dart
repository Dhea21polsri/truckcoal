import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textView(
  EdgeInsetsGeometry margin,
  String text,
  TextAlign posisi,
  Color warna,
  FontWeight tebal,
  double ukuran,
) {
  return Container(
    margin: margin,
    child: Text(
      text,
      textAlign: posisi,
      style: GoogleFonts.lexend(
        color: warna,
        fontWeight: tebal,
        fontSize: ukuran,
      ),
    ),
  );
}

buttonBesarView(String text, VoidCallback onPressed, Color color) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: GoogleFonts.lexend(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: const Color.fromARGB(255, 5, 5, 5),
      ),
    ),
  );
}
