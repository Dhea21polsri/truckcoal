import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';

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
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            children: [
              const Text(
                'DETAIL TRANSAKSI TIMBANGAN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              infoItem('Truck Name', data['truck']),
              infoItem('Status', data['status']),
              infoItem('Lokasi Timbang', data['lokasiTimbang']),
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

  Widget infoItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text('$title')),
          Text(':  ', style: TextStyle(fontWeight: FontWeight.bold)),
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
}
