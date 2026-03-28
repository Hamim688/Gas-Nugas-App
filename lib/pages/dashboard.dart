import 'package:flutter/material.dart';
import 'package:proect_gas_nugas/components/category_list.dart';
import 'package:proect_gas_nugas/components/task_card.dart';
import 'package:proect_gas_nugas/pages/add_task.dart';
import 'package:proect_gas_nugas/utils/task_filter.dart';
import 'package:proect_gas_nugas/controllers/task_controllers.dart';
import 'package:proect_gas_nugas/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDashboard extends StatefulWidget {
  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  DateTime _parseTanggalLokal(String tgl) {
    try {
      // Coba gaya bule dulu (buat jaga-jaga kalau ada data format lama)
      return DateTime.parse(tgl);
    } catch (e) {
      // Kalau error, kita bongkar paksa gaya lokal "25/3/2026 10:49"
      List<String> bagian = tgl.split(' '); // Pisah tanggal dan jam
      List<String> tglBagian = bagian[0].split('/'); // Pisah 25, 3, 2026

      int hari = int.parse(tglBagian[0]);
      int bulan = int.parse(tglBagian[1]);
      int tahun = int.parse(tglBagian[2]);

      return DateTime(tahun, bulan, hari); // Susun ulang ke format bule
    }
  }

  // Default Kategori
  String categoryAktif = "Semua";

  // List Kategori
  final List<String> daftarKategori = [
    "Semua",
    "Kuliah",
    "Organisasi",
    "Pribadi",
  ];

  void _tampilMenuProfile(BuildContext context, String email, String inisial) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Biar kotaknya nggak menuhi layar
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF09637E),
                child: Text(
                  inisial,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                email,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Tutup popup profile ini dulu
                  _konfirmasiLogout(context); // Baru buka dialog konfirmasi
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  "Keluar Akun",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Yakin mau keluar?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Nanti kalau mau nugas lagi lu harus masukin email sama password lagi lho.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Batal keluar
              child: Text(
                "Batal",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Tutup dialognya
                await FirebaseAuth.instance.signOut(); // LOGOUT
              },
              child: Text(
                "Keluar",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------
    // 1. SIAPKAN LOGIKA TANGGAL (Biar itungannya akurat jam 00:00)
    // -----------------------------------------------------------
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // buat bikin avatar
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "User";
    final inisial = email.isNotEmpty ? email[0].toUpperCase() : "U";

    return StreamBuilder<List<TaskModel>>(
      stream: TaskController().getTugasStream(),
      builder: (context, snapshot) {
        // 2. CEK LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 3. TERJEMAHIN DATA FIREBASE JADI MAP (Biar logic lu gak rusak)
        List<Map<String, dynamic>> dataTugasFirebase = [];
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          dataTugasFirebase = snapshot.data!.map((tugas) {
            return {
              "id": tugas.id,
              "judul": tugas.judul,
              "deskripsi": tugas.deskripsi,
              "kategori": tugas.kategori,
              "dateline": tugas.dateline,
              "status": tugas.status,
            };
          }).toList();
        }

        // 4. UBAH KATA 'tugas' JADI 'dataTugasFirebase' DI HITUNGAN LU
        // Kodingan lu yang lama: int jmlSelesai = tugas.where...
        // Ubah jadi gini:
        int jmlSelesai = dataTugasFirebase
            .where((t) => t["status"] == true)
            .length;

        int jmlTerlambat = dataTugasFirebase.where((t) {
          if (t["status"] == true) return false;
          DateTime date = _parseTanggalLokal(t["dateline"]);
          DateTime dateOnly = DateTime(date.year, date.month, date.day);
          return dateOnly.isBefore(today);
        }).length;

        int jmlMenunggu = dataTugasFirebase.where((t) {
          if (t["status"] == true) return false;
          DateTime date = _parseTanggalLokal(t["dateline"]);
          DateTime dateOnly = DateTime(date.year, date.month, date.day);
          return !dateOnly.isBefore(today);
        }).length;

        // -----------------------------------------------------------
        // 2. HITUNG JUMLAH TUGAS (Auto Update)
        // -----------------------------------------------------------

        final List<Widget> tabs = [
          Tab(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.alarm, size: 40, color: Color(0xFFEBF4F6)),
                SizedBox(height: 4), // Jarak antara icon dan teks
                Text(
                  "$jmlMenunggu Tugas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Menunggu",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
          Tab(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 40,
                  color: Color(0xFFEBF4F6),
                ),
                SizedBox(height: 4),
                Text(
                  "$jmlSelesai Tugas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Selesai",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
          Tab(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 40, color: Color(0xFFEBF4F6)),
                SizedBox(height: 4),
                Text(
                  "$jmlTerlambat Tugas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Terlambat",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
        ];

        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            // Buat Judul Aplikasi
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "GAS NUGAS!!!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      // Pas dipencet, panggil pop-up menu profile
                      _tampilMenuProfile(context, email, inisial);
                    },
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Color(0xFF7AB2B2),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(0xFF09637E),
                        child: Text(
                          inisial,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Buat Tabbarnya
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  height: 133,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF088395), Color(0xFF7AB2B2)],
                    ),
                  ),
                  child: TabBar(
                    tabs: tabs,
                    dividerColor: Colors.transparent,
                    indicatorColor: Color(0xFFEBF4F6),
                    indicatorWeight: 3,
                  ),
                ),

                // Tulisan Kategori
                Padding(
                  padding: EdgeInsets.only(left: 25, top: 15),
                  child: Text(
                    "Kategori",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Pilihan Kategory
                CategoryList(
                  daftarkategori: daftarKategori,
                  categoryAktif: categoryAktif,
                  onCategoryChanged: (kategoriBaru) {
                    setState(() {
                      categoryAktif = kategoriBaru;
                    });
                  },
                ),

                // Tulisan List Tugas
                Padding(
                  padding: EdgeInsets.only(left: 25, top: 10, bottom: 10),
                  child: Text(
                    "List Tugas",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Buat List Tugasnya
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTaskList("menunggu", dataTugasFirebase),
                      _buildTaskList("selesai", dataTugasFirebase),
                      _buildTaskList("terlambat", dataTugasFirebase),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddTask();
                    },
                  ),
                );
              },
              backgroundColor: Color(0xFFEBF4F6),
              elevation: 4,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xFF09637E), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.add, size: 25, color: Color(0xFF09637E)),
            ),
          ),
        );
      },
    );
  }

  // Fungsi UI jadi super pendek!
  Widget _buildTaskList(String tipeTab, List<Map<String, dynamic>> semuaTugas) {
    // 1. Panggil Utils buat minta data yang udah disaring
    List<Map<String, dynamic>> filteredTasks = TaskFilter.filterByTab(
      semuaTugas: semuaTugas,
      kategoriAktif: categoryAktif,
      tipeTab: tipeTab,
    );

    // 2. Cek kalau kosong, tampilin gambar kosong (Optional tapi keren)
    if (filteredTasks.isEmpty) {
      return Center(child: Text("Tidak ada tugas $tipeTab!"));
    }

    // 3. Render Datanya
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10),
      children: filteredTasks.map((tugasItem) {
        return Dismissible(
          key: Key(tugasItem['id']),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 25.0),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.delete_sweep, color: Colors.white, size: 30),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "Hapus Tugas?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "Lu yakin mau ngapus tugas '${tugasItem["judul"]}'? Data yang udah dihapus nggak bisa balik lagi lho.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(false), // Batal geser
                      child: Text(
                        "Batal",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(true), // Lanjut hapus
                      child: Text(
                        "Hapus",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            TaskController().hapusTugas(tugasItem["id"]);

            // Kasih notif ke user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Tugas '${tugasItem["judul"]}' berhasil dihapus 🗑️",
                ),
              ),
            );
          },
          child: TaskCard(tugasItem: tugasItem),
        );
      }).toList(),
    );
  } // <-- Tutupnya fungsi _buildTaskList
}
