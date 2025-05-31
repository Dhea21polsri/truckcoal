import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

labelView(String text) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: GoogleFonts.lexend().fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Colors.black87,
    ),
  );
}

inputtambahuserView(
  TextEditingController controller, {
  String? hint,
  bool obscure = false,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 3)),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontFamily: GoogleFonts.lexend().fontFamily),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(fontFamily: GoogleFonts.lexend().fontFamily),
    ),
  );
}

dropdownroleView({
  required List<String> roles,
  required String? selectedRole,
  required Function(String?) onChanged,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 6),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 3)),
      ],
    ),
    height: 50,
    child: DropdownButton<String>(
      value: selectedRole,
      isExpanded: true,
      underline: const SizedBox(),
      hint: Text(
        'Pilih Jabatan',
        style: TextStyle(fontFamily: GoogleFonts.lexend().fontFamily),
      ),
      icon: const Icon(Icons.arrow_drop_down, size: 24),
      style: TextStyle(
        fontFamily: GoogleFonts.lexend().fontFamily,
        fontSize: 16,
        color: Colors.black87,
      ),
      items:
          roles.map((String role) {
            return DropdownMenuItem<String>(value: role, child: Text(role));
          }).toList(),
      onChanged: onChanged,
    ),
  );
}

infoItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text('$title')),
          Text(':  ', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: GoogleFonts.lexend().fontFamily,
            )),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
}