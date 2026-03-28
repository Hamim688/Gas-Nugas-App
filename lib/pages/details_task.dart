import 'package:flutter/material.dart';
import 'package:proect_gas_nugas/components/app_bar.dart';
import 'package:proect_gas_nugas/pages/edit_task.dart';
import 'package:proect_gas_nugas/utils/color_task.dart';
import 'package:proect_gas_nugas/controllers/task_controllers.dart';
import 'package:proect_gas_nugas/models/task_model.dart';

class DetailsTask extends StatelessWidget {
  final Map<String, dynamic> tugasItem;

  const DetailsTask({super.key, required this.tugasItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(judul: "Detail Tugas"),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tugasItem["judul"],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: ColorTask.getColor(
                  tugasItem["dateline"],
                ).withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Text(
                tugasItem["kategori"],
                style: TextStyle(
                  // Teksnya kita pakai warna solidnya, atau kalau kurang teges bisa lu ganti Colors.black
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Deadline : ${tugasItem["dateline"]}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),

            Text(
              "Deskripsi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              tugasItem["deskripsi"],
              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EditTask(tugasItemLama: tugasItem);
                      },
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Color(0xFF09637E)),
                label: Text(
                  "Edit Tugas",
                  style: TextStyle(
                    color: Color(0xFF09637E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF09637E), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            if (tugasItem['status'] == false)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    TaskModel tugasSelesai = TaskModel(
                      id: tugasItem['id'],
                      judul: tugasItem['judul'],
                      deskripsi: tugasItem['deskripsi'],
                      kategori: tugasItem['kategori'],
                      dateline: tugasItem['dateline'],
                      status: true, // Ubah statusnya jadi selesai
                    );

                    try {
                      // 2. Panggil kurir buat nimpa data di gudang Firebase
                      await TaskController().updateTugas(
                        tugasItem['id'],
                        tugasSelesai,
                      );

                      // 3. Kalau sukses, kasih tau user terus tendang balik ke Dashboard
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Yeyyy! Tugas kelar juga 🥳"),
                          ),
                        );
                        Navigator.pop(context); // Otomatis balik ke beranda
                      }
                    } catch (e) {
                      // Jaga-jaga kalau internet tiba-tiba ngadat
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Gagal update status nih: $e"),
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text(
                    "Tandai Selesai",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF09637E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
