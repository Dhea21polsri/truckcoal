import 'package:flutter/material.dart';
import 'package:truckcoal_app/widgets/textview.dart';

appBarView(judul) {
  return AppBar(
    backgroundColor: const Color(0xFF24685B),
    title: textView(
      EdgeInsets.zero,
      judul,
      TextAlign.left,
      Colors.white,
      FontWeight.bold,
      15.0,
    ),
  );
}

appTambahView(judul, ditekan) {
  return AppBar(
    backgroundColor: const Color(0xFF24685B),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textView(
          EdgeInsets.zero,
          judul,
          TextAlign.left,
          Colors.white,
          FontWeight.bold,
          15.0,
        ),
        Padding(
          padding: EdgeInsets.only(right: 3.0),
          child: IconButton(
            onPressed: ditekan,
            icon: Icon(Icons.add_box_rounded, color: Colors.white, size: 30.0),
          ),
        ),
      ],
    ),
  );
}

applogoutView(String judul, VoidCallback onLogout) {
  return AppBar(
    backgroundColor: const Color(0xFF24685B),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textView(
          EdgeInsets.zero,
          judul,
          TextAlign.left,
          Colors.white,
          FontWeight.bold,
          15.0,
        ),
        Padding(
          padding: EdgeInsets.only(right: 3.0),
          child: IconButton(
            onPressed: onLogout,
            icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30.0),
          ),
        ),
      ],
    ),
  );
}

