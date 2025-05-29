import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

inputView(
  String label,
  TextEditingController controller, {
  bool obscure = false,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: label,
      hintStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.lexend().fontFamily,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
    validator:
        (value) =>
            value == null || value.isEmpty ? '$label tidak boleh kosong' : null,
  );
}
