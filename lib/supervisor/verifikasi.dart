import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:truckcoal_app/supervisor/detailverifikasi.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/supervisor/ekspordata.dart'; // Import halaman Ekspor Data

class Verifikasi extends StatefulWidget {
  const Verifikasi({super.key});

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView('Validasi'),
      body: Container(
        decoration: backgroundView3(), // Menambahkan dekorasi backgroundView3()
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Ekspordata()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC1EA99),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Ekspor Data',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.lexend().fontFamily,
                  ),
                ),
              ),
            ),

            // StreamBuilder untuk menampilkan daftar data verifikasi
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('record')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Belum ada riwayat.'));
                  }

                  final data = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final doc = data[index];
                      final d = doc.data() as Map<String, dynamic>;
                      d['id'] = doc.id;

                      final truck = d['truck'] ?? '-';
                      final createdAt =
                          d['createdAt'] != null
                              ? (d['createdAt'] as Timestamp).toDate()
                              : DateTime.now();
                      final dateFormatted = DateFormat(
                        'd/M/yyyy HH:mm',
                      ).format(createdAt);

                      final isValidated = d['isValidated'] ?? false;
                      final statusText =
                          isValidated
                              ? 'Sudah Diverifikasi'
                              : 'Belum Diverifikasi';

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECB3),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 6,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Truck Name :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  truck,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateFormatted,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isValidated ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.list_alt,
                                size: 28,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailVerifikasi(
                                          data: d,
                                          isValidated: isValidated,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
