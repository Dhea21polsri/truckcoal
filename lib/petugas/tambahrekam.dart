import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  void calculateCoalWeight() {
    final truckWeight = double.tryParse(truckWeightController.text) ?? 0;
    final scaleWeight = double.tryParse(scaleWeightController.text) ?? 0;
    final coalWeight = scaleWeight - truckWeight;
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

  Future<void> saveTemporaryData() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> data = {
      'truck': truckNameController.text.trim(),
      'lokasi': locationController.text.trim(),
      'status': status,
      'ritase': ritase,
      'shift': shift,
      'masuk': masukDate.toIso8601String(),
      'keluar': keluarDate.toIso8601String(),
      'truckWeight': truckWeightController.text.trim(),
      'scaleWeight': scaleWeightController.text.trim(),
    };

    await prefs.setString('temp_rekam_data', jsonEncode(data));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data sementara berhasil disimpan.')),
    );
  }

  Future<void> loadTemporaryData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('temp_rekam_data');
    if (jsonString != null) {
      final data = jsonDecode(jsonString);

      setState(() {
        truckNameController.text = data['truck'] ?? '';
        locationController.text = data['lokasi'] ?? '';
        status = data['status'] ?? 'Retail';
        ritase = data['ritase'] ?? '1';
        shift = data['shift'] ?? '1';
        masukDate = DateTime.tryParse(data['masuk']) ?? DateTime.now();
        keluarDate = DateTime.tryParse(data['keluar']) ?? DateTime.now();
        truckWeightController.text = data['truckWeight'] ?? '';
        scaleWeightController.text = data['scaleWeight'] ?? '';
      });
    }
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
        'proses': 'Belum Terverifikasi',
      });

      setState(() {
        submittedData.add({
          'id': docRef.id,
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
          'proses': 'Belum Terverifikasi',
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

      // Hapus data sementara
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('temp_rekam_data');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Data berhasil disimpan.')));
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
      body: Stack(
        children: [
          Container(
            decoration: backgroundView3(),
            height: double.infinity,
            width: double.infinity,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                    buttonView('Keep', saveTemporaryData, Color(0xFFD7F5BA)),
                    buttonView('Submit', submitForm, Color(0xFFD7F5BA)),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
