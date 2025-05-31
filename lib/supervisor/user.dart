import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appTambahView('User', () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TambahUser()),
        );
      }),
      body: Container(
        decoration: backgroundView3(),
        padding: const EdgeInsets.all(10),

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
            final totalUsers = docs.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jumlah User: $totalUsers',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
