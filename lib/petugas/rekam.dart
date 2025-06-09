import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truckcoal_app/petugas/tambahrekam.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';

class Rekam extends StatefulWidget {
  const Rekam({super.key});

  @override
  State<Rekam> createState() => _RekamState();
}

class _RekamState extends State<Rekam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appTambahView('My Record', () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TambahRekam()),
        );
      }),
      body: Container(
        decoration: backgroundView3(),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
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
                    return const Center(child: Text('Tidak ada data.'));
                  }

                  final data = snapshot.data!.docs;

                  String formatDate(String iso) {
                    final dt = DateTime.tryParse(iso) ?? DateTime.now();
                    return DateFormat('dd/MM/yyyy\nHH:mm').format(dt);
                  }

                  return Container(
                    width: double.infinity,
                    child: DataTable(
                      columnSpacing: 5,
                      columns: const [
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Truck',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Status',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Waktu\nKeluar',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Waktu\nMasuk',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Coal\nWeight',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                      rows:
                          data.take(7).map((doc) {
                            final d = doc.data() as Map<String, dynamic>;

                            return DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      d['truck'] ?? '-\n',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize:
                                            13.0, // Menyesuaikan ukuran font
                                      ),
                                    ),
                                  ),
                                ),

                                DataCell(
                                  Center(
                                    child: Text(
                                      d['status'] ?? '-',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      formatDate(d['keluar'] ?? ''),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            13.0, // Menyesuaikan ukuran font
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      formatDate(d['masuk'] ?? ''),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            13.0, // Menyesuaikan ukuran font
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      '${(d['coalWeight'] ?? 0)}\nKg',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            13.0, // Menyesuaikan ukuran font
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
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
