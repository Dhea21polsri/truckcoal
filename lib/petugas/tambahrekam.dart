import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';
import 'package:truckcoal_app/widgets/rekamview.dart'; // Pastikan ini mengimpor dropdownShiftView

class TambahRekam extends StatefulWidget {
  // Hapus 'const' di sini sesuai perbaikan sebelumnya
  TambahRekam({super.key});

  @override
  State<TambahRekam> createState() => _TambahRekamState();
}

class _TambahRekamState extends State<TambahRekam> {
  final truckNameController = TextEditingController();
  final locationController = TextEditingController();
  final truckWeightController = TextEditingController();
  final scaleWeightController = TextEditingController();
  final driverNameController = TextEditingController();
  final unitController = TextEditingController();
  final suratJalanController = TextEditingController();

  String status = 'Retail';
  String ritase = '1';
  String shift = '1';
  String unit = 'Unit Pertambangan Ombilin';

  DateTime masukDate = DateTime.now();
  DateTime keluarDate = DateTime.now();

  List<Map<String, dynamic>> submittedData = [];

  Map<String, List<String>> shiftOfficers = {'1': [], '2': [], '3': []};
  String selectedOfficerName = 'No Officer Selected';

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
    _fetchShiftData();
  }

  Future<void> _fetchShiftData() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('shifts').get();
      Map<String, List<String>> tempFetchedShiftOfficers = {
        '1': [],
        '2': [],
        '3': [],
      };

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        if (data.containsKey('shift') && data.containsKey('namapetugas')) {
          String shiftNumber = data['shift'].toString();
          String officerName = data['namapetugas'].toString();

          if (tempFetchedShiftOfficers.containsKey(shiftNumber)) {
            tempFetchedShiftOfficers[shiftNumber]!.add(officerName);
          } else {
            tempFetchedShiftOfficers[shiftNumber] = [officerName];
          }
        }
      }

      setState(() {
        shiftOfficers = tempFetchedShiftOfficers;
        shift = '1';
        if (shiftOfficers['1'] != null && shiftOfficers['1']!.isNotEmpty) {
          selectedOfficerName = shiftOfficers['1']!.first;
        } else {
          selectedOfficerName = 'No Officer Selected';
        }
      });
    } catch (e) {
      print('Error fetching shift data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load shift data.')));
    }
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
      'officerName': selectedOfficerName,
      'masuk': masukDate.toIso8601String(),
      'keluar': keluarDate.toIso8601String(),
      'truckWeight': truckWeightController.text.trim(),
      'scaleWeight': scaleWeightController.text.trim(),
      'driverName': driverNameController.text.trim(),
      'unit': unitController.text.trim(),
      'suratJalan': suratJalanController.text.trim(),
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
        selectedOfficerName = data['officerName'] ?? 'No Officer Selected';

        masukDate = DateTime.tryParse(data['masuk']) ?? DateTime.now();
        keluarDate = DateTime.tryParse(data['keluar']) ?? DateTime.now();
        truckWeightController.text = data['truckWeight'] ?? '';
        scaleWeightController.text = data['scaleWeight'] ?? '';
        driverNameController.text = data['driverName'] ?? '';
        unitController.text = data['unit'] ?? 'Unit Pertambangan Ombilin';
        suratJalanController.text = data['suratJalan'] ?? '';
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
        'officerName': selectedOfficerName,
        'masuk': masukDate.toIso8601String(),
        'keluar': keluarDate.toIso8601String(),
        'truckWeight': truckWeight,
        'scaleWeight': scaleWeight,
        'coalWeight': coalWeight,
        'driverName': driverNameController.text.trim(),
        'unit': unitController.text.trim(),
        'suratJalan': suratJalanController.text.trim(),
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
          'officerName': selectedOfficerName,
          'masuk': masukDate.toIso8601String(),
          'keluar': keluarDate.toIso8601String(),
          'truckWeight': truckWeight,
          'scaleWeight': scaleWeight,
          'coalWeight': coalWeight,
          'driverName': driverNameController.text.trim(),
          'unit': unitController.text.trim(),
          'suratJalan': suratJalanController.text.trim(),
          'proses': 'Belum Terverifikasi',
        });

        // Clear all fields and reset to default values after submission
        truckNameController.clear();
        locationController.clear();
        truckWeightController.clear();
        scaleWeightController.clear();
        driverNameController.clear();
        unitController.text = 'Unit Pertambangan Ombilin'; // Set default value
        suratJalanController.clear();
        ritase = '1';
        status = 'Retail';
        masukDate = DateTime.now();
        keluarDate = DateTime.now();
        calculateCoalWeight();

        shift = '1';
        if (shiftOfficers['1'] != null && shiftOfficers['1']!.isNotEmpty) {
          selectedOfficerName = shiftOfficers['1']!.first;
        } else {
          selectedOfficerName = 'No Officer Selected';
        }
      });

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
    List<DropdownMenuItem<String>> shiftDropdownItems = [];
    List<String> sortedShiftNumbers = shiftOfficers.keys.toList()..sort();

    for (String shiftNum in sortedShiftNumbers) {
      List<String> officers = shiftOfficers[shiftNum] ?? [];
      String officersText;
      if (officers.isEmpty) {
        officersText = 'No officers available';
      } else {
        officersText = officers.join(
          ',\n',
        ); // Menggunakan \n untuk potensi baris baru
      }

      shiftDropdownItems.add(
        DropdownMenuItem<String>(
          value: shiftNum,
          child: Text(
            'Shift $shiftNum ($officersText)',
            softWrap: true,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

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
                // Input Truck Name dan Status
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

                // Input Nama Supir
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelView('Nama Supir'),
                          rekamView(controller: driverNameController),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Dropdown Unit Asal
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelView('Unit Asal'),
                          dropdownunitView(
                            value: unit, // Gunakan unit langsung sebagai nilai
                            options: [
                              'Unit Penambangan Ombilin',
                              'Unit Dermaga Kertapati',
                              'Unit Pertambangan Tanjung Enim',
                              'Unit Dermaga Kuala Tanjung',
                              'PT Huadian Bukit Asam Power (HBAP)',
                              'PT Bukit Asam Methana Enim',
                              'PT Bukit Multi Investama (BMI)',
                            ],
                            onChanged: (val) {
                              setState(() {
                                unit =
                                    val!; // Menyimpan nilai yang dipilih langsung ke unit
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Input No Surat Jalan
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelView('No Surat Jalan'),
                          rekamView(controller: suratJalanController),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Input Lokasi
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
                  ],
                ),
                const SizedBox(height: 10),

                // Dropdown Ritase dan Shift
                Row(
                  children: [
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
                          dropdownShiftView(

                            value: shift,
                            items:
                                shiftDropdownItems,
                            onChanged: (String? newValue) {
                              setState(() {
                                shift = newValue!;
                                if (shiftOfficers[shift] != null &&
                                    shiftOfficers[shift]!.isNotEmpty) {
                                  selectedOfficerName =
                                      shiftOfficers[shift]!.first;
                                } else {
                                  selectedOfficerName = 'No Officer Selected';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Input Truck Weight and Scale Weight
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

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buttonView(
                      'Keep',
                      saveTemporaryData,
                      const Color(0xFFD7F5BA),
                    ),
                    buttonView('Submit', submitForm, const Color(0xFFD7F5BA)),
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
