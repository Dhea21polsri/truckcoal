import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/tambahuserview.dart';

class DetailHistory extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailHistory({super.key, required this.data});

  String formatDateTime(dynamic timestamp) {
    if (timestamp == null) return '-';
    DateTime dt =
        timestamp is String ? DateTime.parse(timestamp) : timestamp.toDate();
    return DateFormat('dd/MM/yyyy  HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView('Detail History'),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: backgroundView3(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(
                'DETAIL TRANSAKSI TIMBANGAN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: GoogleFonts.lexend().fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              infoItem('Truck Name', data['truck']),
              infoItem('Status', data['status']),
              infoItem('Nama Supir', data['driverName']),
              infoItem('Unit Asal', data['unit']),
              infoItem('No Surat Jalan', data['suratJalan']),
              infoItem('Lokasi Timbang', data['lokasi']),
              infoItem('Ritase', data['ritase']?.toString()),
              infoItem('Shift', data['shift']?.toString()),
              infoItem('Waktu Masuk', formatDateTime(data['masuk'])),
              infoItem('Truck Weight', '${data['truckWeight'] ?? 0} Kg'),
              infoItem('Waktu Keluar', formatDateTime(data['keluar'])),
              infoItem('Scale Weight', '${data['scaleWeight'] ?? 0} Kg'),
              infoItem(
                'Coal Weight',
                '${(data['coalWeight'] ?? 0).toStringAsFixed(3)} Kg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
