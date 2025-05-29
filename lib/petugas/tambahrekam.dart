import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/rekamview.dart';

class TambahRekam extends StatefulWidget {
  const TambahRekam({super.key});

  @override
  State<TambahRekam> createState() => _TambahRekamState();
}

class _TambahRekamState extends State<TambahRekam> {
  final truckNameController = TextEditingController();
  final locationController = TextEditingController();
  final truckWeightController = TextEditingController();
  final scaleWeightController = TextEditingController();

  String status = 'Retail';
  String ritase = '1';
  String shift = '1';

  DateTime masukDate = DateTime.now();
  DateTime keluarDate = DateTime.now();

  List<Map<String, dynamic>> submittedData = [];

  void calculateCoalWeight() {
    final truckWeight = double.tryParse(truckWeightController.text) ?? 0;
    final scaleWeight = double.tryParse(scaleWeightController.text) ?? 0;
    final coalWeight = scaleWeight - truckWeight;

    // Tambahkan logika lainnya bila perlu
  }

  Future<void> _pickDateTime({required bool isMasuk}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isMasuk) {
        masukDate = selectedDateTime;
      } else {
        keluarDate = selectedDateTime;
      }
    });
  }

  void submitForm() async {
    try {
      final truckName = truckNameController.text.trim();
      final lokasi = locationController.text.trim();
      final truckWeight =
          double.tryParse(truckWeightController.text.trim()) ?? 0;
      final scaleWeight =
          double.tryParse(scaleWeightController.text.trim()) ?? 0;
      final coalWeight = scaleWeight - truckWeight;

      if (truckName.isEmpty || lokasi.isEmpty || coalWeight <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap lengkapi data dengan benar.')),
        );
        return;
      }

      final docRef = await FirebaseFirestore.instance.collection('record').add({
        'truck': truckName,
        'lokasi': lokasi,
        'status': status,
        'ritase': ritase,
        'shift': shift,
        'masuk': masukDate.toIso8601String(),
        'keluar': keluarDate.toIso8601String(),
        'truckWeight': truckWeight,
        'scaleWeight': scaleWeight,
        'coalWeight': coalWeight,
        'createdAt': FieldValue.serverTimestamp(),
        'proses': 'Belum Terverifikasi', // ✅ Tambahan field proses
      });

      setState(() {
        submittedData.add({
          'truck': truckName,
          'lokasi': lokasi,
          'status': status,
          'ritase': ritase,
          'shift': shift,
          'masuk': masukDate.toIso8601String(),
          'keluar': keluarDate.toIso8601String(),
          'truckWeight': truckWeight,
          'scaleWeight': scaleWeight,
          'coalWeight': coalWeight,
          'proses': 'Belum Terverifikasi', // ✅ simpan juga untuk tabel
        });

        truckNameController.clear();
        locationController.clear();
        truckWeightController.clear();
        scaleWeightController.clear();
        ritase = '1';
        shift = '1';
        status = 'Retail';
        masukDate = DateTime.now();
        keluarDate = DateTime.now();
        calculateCoalWeight();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil disimpan ke Firestore.')),
      );
    } catch (e) {
      print('Error saat submit: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView('Tambah Record'),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: backgroundView3(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelView('Truck Name'),
                        rekamView(controller: truckNameController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelView('Status'),
                        dropdownstatusView(
                          value: status,
                          options: ['Retail', 'Pindah Stok'],
                          onChanged: (val) {
                            setState(() {
                              status = val!;
                              calculateCoalWeight();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelView('Lokasi'),
                        rekamView(controller: locationController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelView('Ritase'),
                        dropdownVIew(
                          value: ritase,
                          options: ['1', '2', '3'],
                          onChanged: (val) => setState(() => ritase = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelView('Shift'),
                        dropdownVIew(
                          value: shift,
                          options: ['1', '2', '3'],
                          onChanged: (val) => setState(() => shift = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: datetimeView(
                      label: 'Waktu Masuk',
                      dateTime: masukDate,
                      onTap: () => _pickDateTime(isMasuk: true),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelView('Truck Weight'),
                        rekamView(
                          controller: truckWeightController,
                          suffixText: 'Kg',
                          keyboardType: TextInputType.number,
                          onChanged: (_) => calculateCoalWeight(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: datetimeView(
                      label: 'Waktu Keluar',
                      dateTime: keluarDate,
                      onTap: () => _pickDateTime(isMasuk: false),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelView('Scale Weight'),
                        rekamView(
                          controller: scaleWeightController,
                          suffixText: 'Kg',
                          keyboardType: TextInputType.number,
                          onChanged: (_) => calculateCoalWeight(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buttonView('Keep', calculateCoalWeight, Color(0xFFD7F5BA)),
                  buttonView('Submit', submitForm, Color(0xFFD7F5BA)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(258, 152, 249, 249),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 3),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 10,
                    columns: [
                      DataColumn(label: Text('Truck\nName')),
                      const DataColumn(label: Text('Status')),
                      const DataColumn(label: Text('Waktu\nKeluar')),
                      const DataColumn(label: Text('Waktu\nMasuk')),
                      const DataColumn(label: Text('Coal\nWeight')),
                      const DataColumn(label: Text('Proses')), // ✅ kolom baru
                    ],
                    rows:
                        submittedData.map<DataRow>((entry) {
                          return DataRow(
                            cells: [
                              DataCell(Text(entry['truck'])),
                              DataCell(Text(entry['status'])),
                              DataCell(
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy HH:mm',
                                  ).format(DateTime.parse(entry['keluar'])),
                                ),
                              ),
                              DataCell(
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy HH:mm',
                                  ).format(DateTime.parse(entry['masuk'])),
                                ),
                              ),
                              DataCell(Text('${entry['coalWeight']} Kg')),
                              DataCell(
                                Text(entry['proses'] ?? 'Belum Terverifikasi'),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
