import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

kolominputprofilView(String value) {
    return Container(
      width: double.infinity, 
      height: 40, 
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              value, 
              style: TextStyle(
                fontFamily: GoogleFonts.lexend().fontFamily,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Membuat widget untuk alamat dengan kotak lebih besar
kolominputalamatView(String value) {
    return Container(
      width: double.infinity, // Mengatur lebar container agar mengisi layar
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
            fontFamily: GoogleFonts.lexend().fontFamily,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
}

inputeditprofilView(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
          fontFamily:GoogleFonts.lexend().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: " $label",
            ),
          ),
        ),
      ],
    );
  }
  
