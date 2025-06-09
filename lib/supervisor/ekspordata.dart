import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';

class Ekspordata extends StatefulWidget {
  const Ekspordata({super.key});

  @override
  EkspordataState createState() => EkspordataState();
}

class EkspordataState extends State<Ekspordata> {
  String? selectedStatus;
  String? selectedMonth;
  final List<String> statusList = ['Semua', 'Retail', 'Pindah Stok'];
  final List<String> monthList = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // Fungsi untuk mengambil data dari Firestore berdasarkan bulan dan status
  Future<List<Map<String, dynamic>>> fetchData() async {
    final now = DateTime.now();
    final monthNumber = monthList.indexOf(selectedMonth ?? '') + 1;
    final startDate = DateTime(now.year, monthNumber, 1);
    final endDate = DateTime(
      now.year,
      monthNumber + 1,
      1,
    ).subtract(const Duration(days: 1));

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('record')
            .where('createdAt', isGreaterThanOrEqualTo: startDate)
            .where('createdAt', isLessThanOrEqualTo: endDate)
            .where(
              'status',
              isEqualTo:
                  selectedStatus == 'Semua'
                      ? FieldValue.arrayUnion(['Retail', 'Pindah Stok'])
                      : selectedStatus,
            )
            .get();

    return querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
  }

  // Fungsi untuk mengekspor data ke Excel
  Future<void> generateExcel() async {
    var excel = Excel.createExcel();
    final data = await fetchData();

    var sheetRetail = excel['Retail'];
    var sheetPindahStok = excel['Pindah Stok'];

    // Menambahkan header ke kedua sheet
    var header = [
      'Truck Name',
      'Location',
      'Product',
      'Waktu',
      'Ritase',
      'ScaleWeight',
      'TruckWeight',
      'CoalWeight',
      'Shift',
    ];

    sheetRetail.appendRow(header);
    sheetPindahStok.appendRow(header);

    for (var item in data) {
      List<String> row = [
        item['truck'] ?? '',
        item['location'] ?? '',
        item['produk'] ?? '',
        formatDate(item['waktu'] ?? DateTime.now()),
        item['ritase'].toString(),
        item['scaleWeight'].toString(),
        item['truckWeight'].toString(),
        item['coalWeight'].toString(),
        item['shift'].toString(),
      ];

      if (item['status'] == 'Retail') {
        sheetRetail.appendRow(row);
      } else if (item['status'] == 'Pindah Stok') {
        sheetPindahStok.appendRow(row);
      }
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/exported_data.xlsx');
    var excelBytes = excel.encode()!;

    // Menyimpan file
    await file.writeAsBytes(excelBytes);

    // Membuka file secara otomatis setelah ekspor
    await OpenFile.open(file.path);

    // Menampilkan konfirmasi bahwa file telah disimpan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File Excel telah disimpan di: ${file.path}')),
    );
  }

  // Fungsi untuk mengekspor data ke PDF
  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final data = await fetchData();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Ekspor Data - Status: $selectedStatus',
                style: pw.TextStyle(fontSize: 24),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>[
                    'Truck Name',
                    'Location',
                    'Product',
                    'Waktu',
                    'Ritase',
                    'ScaleWeight',
                    'TruckWeight',
                    'CoalWeight',
                    'Shift',
                  ],
                  ...data.map(
                    (e) => [
                      e['truck'] ?? '',
                      e['location'] ?? '',
                      e['produk'] ?? '',
                      formatDate(e['waktu'] ?? DateTime.now()),
                      e['ritase'].toString(),
                      e['scaleWeight'].toString(),
                      e['truckWeight'].toString(),
                      e['coalWeight'].toString(),
                      e['shift'].toString(),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/exported_data.pdf');
    await file.writeAsBytes(await pdf.save());

    // Membuka file secara otomatis setelah ekspor
    await OpenFile.open(file.path);

    // Menampilkan konfirmasi bahwa file telah disimpan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File PDF telah disimpan di: ${file.path}')),
    );
  }

  // Format Waktu ke format dd/MM/yyyy HH:mm
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView('Ekspor Data'),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: backgroundView3(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.lexend().fontFamily,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity, 
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: selectedStatus,
                hint: const Text('Pilih Status'),
                isExpanded: true,
                items:
                    statusList.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown untuk Bulan
            Text(
              'Periode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.lexend().fontFamily,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity, // Membuat lebar container penuh
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: selectedMonth,
                hint: const Text('Pilih Bulan'),
                isExpanded: true,
                items:
                    monthList.map((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedMonth = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center, // Menjaga agar kolom berada di tengah
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: generatePDF,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC1EA99),
                      minimumSize: const Size(350, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Tombol Ekspor Data ke PDF
                    child: Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.lexend().fontFamily,
                      ),
                    ),
                  ),
                  // Tombol Ekspor Data ke Excel
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: generateExcel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7BAB99),
                      minimumSize: const Size(350, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Excel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.lexend().fontFamily,
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
