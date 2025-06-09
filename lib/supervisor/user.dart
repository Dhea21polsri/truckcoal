import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truckcoal_app/supervisor/shift.dart';
import 'package:truckcoal_app/supervisor/tambahuser.dart';
import 'package:truckcoal_app/widgets/appbarview.dart';
import 'package:truckcoal_app/widgets/backgroundview.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserListPageState();
}

class _UserListPageState extends State<User> {
  Stream<QuerySnapshot> getUsersStream() {
    return FirebaseFirestore.instance.collection('user').snapshots();
  }

  Stream<QuerySnapshot> getShiftsStream() {
    return FirebaseFirestore.instance.collection('shifts').snapshots();
  }

  Future<void> deleteUser(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(docId).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User berhasil dihapus')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus user: $e')));
    }
  }

  Future<void> clearShiftData() async {
    try {
      final shifts =
          await FirebaseFirestore.instance.collection('shifts').get();
      for (var shift in shifts.docs) {
        await shift.reference.delete(); // Menghapus semua data shift
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data shift berhasil dihapus, shift baru bisa dibuat.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus data shift: $e')));
    }
  }

  String getCurrentDate() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarView('Operator'),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: backgroundView3(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // JADWAL SHIFT Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'JADWAL SHIFT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getCurrentDate(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ShiftForm()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        // Menanyakan konfirmasi untuk menghapus semua data shift
                        showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: const Text(
                                  'Apakah Anda yakin ingin menghapus semua data shift? Data shift yang sudah ada akan hilang.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(ctx, true);
                                      await clearShiftData();
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Shift Section (from Firestore)
            StreamBuilder<QuerySnapshot>(
              stream: getShiftsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Belum ada data shift.');
                }

                final shifts = snapshot.data!.docs;

                return Column(
                  children: List.generate(3, (i) {
                    final shiftNumber = i + 1;
                    final usersInShift =
                        shifts
                            .where(
                              (doc) =>
                                  (doc.data()
                                      as Map<String, dynamic>)['shift'] ==
                                  shiftNumber,
                            )
                            .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shift $shiftNumber',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...usersInShift.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                bottom: 2,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '• ${data['namapetugas'] ?? 'Tidak diketahui'}',
                                  ),
                                  Text(data['nip'] ?? '-'),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 12),

            // Jumlah User dan tombol tambah
            StreamBuilder<QuerySnapshot>(
              stream: getUsersStream(),
              builder: (context, snapshot) {
                int jumlahUser = 0;
                if (snapshot.hasData) {
                  jumlahUser = snapshot.data!.docs.length;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jumlah User : $jumlahUser',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TambahUser()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

            // List semua user
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Belum ada user.'));
                  }

                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final nip = data['nip'] ?? 'N/A';
                      final name = data['name'] ?? 'Tanpa Nama';
                      final role = data['role'] ?? 'Tidak Diketahui';

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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NIP: $nip',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Role: $role',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black54,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        title: const Text('Konfirmasi Hapus'),
                                        content: const Text(
                                          'Yakin ingin menghapus user ini?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(ctx, false),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(ctx, true),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  await deleteUser(doc.id);
                                }
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
