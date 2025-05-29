import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

labelView(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: GoogleFonts.lexend().fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

rekamView({
    required TextEditingController controller,
    String? suffixText,
    ValueChanged<String>? onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixText: suffixText,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          style:TextStyle(fontFamily: GoogleFonts.lexend().fontFamily, fontSize: 16),
        ),
      ),
    );
  }

  lokasiView({
    required TextEditingController controller,
    String? suffixText,
    ValueChanged<String>? onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 10, left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixText: suffixText,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          style: TextStyle(fontFamily:  GoogleFonts.lexend().fontFamily, fontSize: 16),
        ),
      ),
    );
  }

dropdownVIew({
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items:
              options
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(
                          fontFamily: GoogleFonts.lexend().fontFamily,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          icon: Image.asset(
            'assets/img/down.png', // Path to your asset image
            width: 30, // Adjust the width
            height: 30, // Adjust the height
          ),
        ),
      ),
    );
  }

dropdownstatusView({
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items:
              options
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
            icon: Image.asset(
            'assets/img/down.png', // Path to your asset image
            width: 30, // Adjust the width
            height: 30, // Adjust the height
          ),
        ),
      ),
    );
  }

datetimeView({
    required String label,
    required DateTime dateTime,
    required VoidCallback onTap,
  }) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelView(label),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$formattedDate $formattedTime',
                  style: TextStyle(fontFamily:  GoogleFonts.lexend().fontFamily, fontSize: 16),
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }

buttonView(String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color.fromARGB(255, 5, 5, 5),
        ),
      ),
    );
  }
