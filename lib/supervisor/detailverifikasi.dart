import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';

class DetailVerifikasi extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isValidated;

  const DetailVerifikasi({
    super.key,
    required this.data,
    required this.isValidated,
  });

  @override
  _DetailVerifikasiState createState() => _DetailVerifikasiState();
}

class _DetailVerifikasiState extends State<DetailVerifikasi> {
  bool isLoading = false;

  String formatDateTime(dynamic timestamp) {
    if (timestamp == null) return '-';
    DateTime dt =
        timestamp is String ? DateTime.parse(timestamp) : timestamp.toDate();
    return DateFormat('dd/MM/yyyy  HH:mm').format(dt);
  }

  infoItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text('$title')),
          const Text(':  ', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Future<void> validateRecord() async {
    setState(() => isLoading = true);

    try {
      final docId = widget.data['id'];
      await FirebaseFirestore.instance.collection('record').doc(docId).update({
        'proses': 'sudah diverifikasi',
        'isValidated': true, 
      });

      if (mounted) {
        setState(() {
          widget.data['isValidated'] =
              true; 
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diverifikasi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memverifikasi data: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    final statusText =
        widget.isValidated ? 'Sudah Diverifikasi' : 'Belum Diverifikasi';
    final statusColor = widget.isValidated ? Colors.green : Colors.red;

    return Scaffold(
      appBar: appBarView('Verification'),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: backgroundView3(),
        child: Column(
          children: [
            const Text(
              'DETAIL TRANSAKSI TIMBANGAN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
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
                  const SizedBox(height: 20),

                  // Menampilkan status verifikasi
                  Text(
                    'Status Verifikasi: $statusText',
                    style: TextStyle(fontSize: 16, color: statusColor),
                  ),
                  const SizedBox(height: 20),

                  // Full-width ElevatedButton
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed:
                          widget.isValidated || isLoading
                              ? null
                              : validateRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.isValidated
                                ? Colors.grey
                                : Colors.lightGreen.shade200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black38,
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                'Validasi',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
