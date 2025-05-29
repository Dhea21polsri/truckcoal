import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truckcoal_app/petugas/tambahrekam.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('record')
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada data.'));
          }

          final data = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('Truck')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Waktu keluar')),
                          DataColumn(label: Text('Waktu Masuk')),
                          DataColumn(label: Text('Coal Weight')),
                        ],
                        rows:
                            data.map((doc) {
                              final d = doc.data() as Map<String, dynamic>;

                              String formatDate(String iso) {
                                final dt =
                                    DateTime.tryParse(iso) ?? DateTime.now();
                                return DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(dt);
                              }

                              return DataRow(
                                cells: [
                                  DataCell(Text(d['truck'] ?? '-')),
                                  DataCell(Text(d['status'] ?? '-')),
                                  DataCell(Text(formatDate(d['keluar'] ?? ''))),
                                  DataCell(Text(formatDate(d['masuk'] ?? ''))),
                                  DataCell(
                                    Text(
                                      '${(d['coalWeight'] ?? 0).toStringAsFixed(3)} Kg',
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
