import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proect_gas_nugas/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskController {
  // Panggil bos gudang Firebase
  final CollectionReference taskCollection = FirebaseFirestore.instance
      .collection('tugas');
  final auth = FirebaseAuth.instance;

  // Fungsi buat NAMBAH tugas
  Future<void> tambahTugas(TaskModel tugasBaru) async {
    try {
      // Minta UID user yang telah login
      String? currentUid = auth.currentUser?.uid;
      // Tempelin setiap tugasnya dengan UID
      tugasBaru.uid = currentUid;
      // Kita suruh Firebase nambahin data, tapi formatnya wajib lewat cetakan toMap()
      await taskCollection.add(tugasBaru.toMap());
    } catch (e) {
      // Kalau gagal, kita lempar errornya biar bisa ditangkap sama halaman UI
      throw Exception("Gagal nambah tugas: $e");
    }
  }

  Stream<List<TaskModel>> getTugasStream() {
    // Cari User yang sedang login
    String? currentUid = auth.currentUser?.uid;

    return taskCollection.where('uid', isEqualTo: currentUid).snapshots().map((
      snapshot,
    ) {
      // Ubah setiap dokumen Firebase jadi TaskModel
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> updateTugas(String idTugas, TaskModel tugasUpdate) async {
    try {
      // Kita cari dokumennya berdasarkan ID, terus kita timpa pakai data baru
      await taskCollection.doc(idTugas).update(tugasUpdate.toMap());
    } catch (e) {
      throw Exception("Yah gagal ngedit tugas: $e");
    }
  }

  Future<void> hapusTugas(String idTugas) async {
    try {
      // Cari file-nya berdasarkan ID, terus musnahkan!
      await taskCollection.doc(idTugas).delete();
    } catch (e) {
      throw Exception("Gagal hapus tugas coy: $e");
    }
  }
}
