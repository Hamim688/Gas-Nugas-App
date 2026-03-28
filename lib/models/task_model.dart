import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id; // ID unik dari Firebase
  String judul;
  String deskripsi;
  String kategori;
  String dateline;
  bool status;
  String? uid; // Untuk Auth

  TaskModel({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.dateline,
    required this.status,
    this.uid,
  });

  // Fungsi 1: Ubah dari Model ke Map (Buat NGIRIM ke Firebase)
  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'dateline': dateline,
      'status': status,
      'uid': uid,
    };
  }

  // Fungsi 2: Ubah dari Map Firebase ke Model (Buat NGAMBIL dari Firebase)
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc
          .id, // Kita simpen ID firebasenya biar nanti gampang kalau mau edit/delete
      judul: data['judul'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      kategori: data['kategori'] ?? 'Lainnya',
      dateline: data['dateline'] ?? '',
      status: data['status'] ?? false,
      uid: data['uid'],
    );
  }
}
