import 'package:flutter/material.dart';
import 'package:proect_gas_nugas/components/app_bar.dart';
import 'package:proect_gas_nugas/controllers/task_controllers.dart';
import 'package:proect_gas_nugas/models/task_model.dart';
import 'package:proect_gas_nugas/utils/pick_time.dart';

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // Buat Pick Time
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController jamController = TextEditingController();
  // Buat Dropdown Kategorinya
  String? kategoriTerpilih;
  final List<String> daftarKategori = [
    "Kuliah",
    "Organisasi",
    "Pribadi",
    "Lainnya",
  ];

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    tanggalController.dispose();
    jamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(judul: "Tambah Tugas"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Judul Tugas",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                height: 45,
                child: TextField(
                  autocorrect: true,
                  autofocus: false,
                  controller: judulController,
                  decoration: InputDecoration(
                    hintText: "Contoh: Tugas Matematika",
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFF147efb),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Deskripsi",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                height: 137,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  autocorrect: true,
                  autofocus: false,
                  controller: deskripsiController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    hintText: "Deskripsi (Opsional)",
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFF147efb),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Deadline",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          height: 50,
                          child: TextField(
                            controller: tanggalController,
                            readOnly: true,
                            onTap: () async {
                              // Minta tolong file utils buat ambilin tanggal
                              DateTime? hasil = await ambilTanggal(context);
          
                              // Kalau ada hasilnya, masukin ke controller
                              if (hasil != null) {
                                setState(() {
                                  tanggalController.text =
                                      "${hasil.day}/${hasil.month}/${hasil.year}";
                                });
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              hintText: "Pilih Tanggal",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF147efb),
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jam Deadline",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          height: 50,
                          child: TextField(
                            controller: jamController,
                            readOnly: true,
                            onTap: () async {
                              // Minta tolong file utils buat ambilin jam
                              TimeOfDay? hasil = await ambilJam(context);
          
                              // Kalau ada hasilnya, masukin ke controller
                              if (hasil != null) {
                                setState(() {
                                  jamController.text =
                                      "${hasil.hour}:${hasil.minute}";
                                });
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.access_time),
                              hintText: "Pilih Jam",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF147efb),
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                "Kategori",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 40),
                // Nggak perlu di-set height manual lagi, DropdownMenu udah rapi dari sananya
                child: DropdownMenu<String>(
                  initialSelection: kategoriTerpilih,
                  hintText: "Pilih Kategori",
          
                  // --- KUNCI 1: Biar lebarnya full ngikutin layar ---
                  expandedInsets: EdgeInsets.zero,
          
                  // --- KUNCI 2: Border kece badai lu masukin ke sini ---
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFF147efb),
                        width: 2.0,
                      ),
                    ),
                  ),
          
                  // --- Bikin daftar itemnya (Pakai DropdownMenuEntry) ---
                  dropdownMenuEntries: daftarKategori.map((String kategori) {
                    return DropdownMenuEntry<String>(
                      value: kategori,
                      label: kategori, // Tulisan yang muncul di menunya
                      style: MenuItemButton.styleFrom(
                        // Opsional: ngatur padding per item biar nggak terlalu renggang
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                      ),
                    );
                  }).toList(),
          
                  // --- Fungsi pas dipilih ---
                  onSelected: (String? nilaiBaru) {
                    setState(() {
                      kategoriTerpilih = nilaiBaru;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // 1. Cek validasi: Judul gak boleh kosong
                  if (judulController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Judul tugas gak boleh kosong!"),
                      ),
                    );
                    return;
                  }
          
                  // 2. Bungkus data pakai "Cetakan" (TaskModel)
                  // Ini bikin data lu aman dari typo dan formatnya pasti bener
                  TaskModel tugasBaru = TaskModel(
                    judul: judulController.text,
                    deskripsi: deskripsiController.text,
                    kategori: kategoriTerpilih ?? "Lainnya",
                    dateline: "${tanggalController.text} ${jamController.text}",
                    status: false, // Default tugas baru pasti belum selesai
                  );
          
                  try {
                    // 3. Panggil "Kurir" (TaskController) buat ngirim ke Firebase
                    await TaskController().tambahTugas(tugasBaru);
          
                    // 4. Kalau sukses, kasih notif terus balik ke Beranda
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Mantap! Tugas berhasil disimpen 🚀"),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    // 5. Kalau apes gagal (misal sinyal ilang)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Yah gagal nyimpen: $e")),
                    );
                  }
                },
                // --- Ngatur gaya tombolnya di sini (styleFrom) ---
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF09637E),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Simpan Tugas",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
