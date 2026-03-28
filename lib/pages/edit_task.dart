import 'package:flutter/material.dart';
import 'package:proect_gas_nugas/components/app_bar.dart';
import 'package:proect_gas_nugas/utils/pick_time.dart';
import 'package:proect_gas_nugas/controllers/task_controllers.dart';
import 'package:proect_gas_nugas/models/task_model.dart';

class EditTask extends StatefulWidget {
  final Map<String, dynamic> tugasItemLama;
  const EditTask({Key? key, required this.tugasItemLama}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  // Buat Pick Time
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
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
  void initState() {
    super.initState();
    judulController.text = widget.tugasItemLama['judul'] ?? "";
    deskripsiController.text = widget.tugasItemLama['deskripsi'] ?? "";
    kategoriTerpilih = widget.tugasItemLama['kategori'];
    String dateline = widget.tugasItemLama['dateline'] ?? "";
    if (dateline.isNotEmpty) {
      List<String> separate = dateline.split(" ");
      if (separate.length == 2) {
        tanggalController.text = separate[0]; // Isinya misal: 25/3/2026
        jamController.text = separate[1]; // Isinya misal: 10:49
      }
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    tanggalController.dispose();
    jamController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(judul: "Edit Tugas"),
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
                  controller: judulController,
                  autocorrect: true,
                  autofocus: false,
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
                  controller: deskripsiController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  autocorrect: true,
                  autofocus: false,
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
                  if (judulController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Judul gak boleh kosong cuy!"),
                      ),
                    );
                    return;
                  }

                  // Cetak datanya pakai Model
                  TaskModel tugasUpdate = TaskModel(
                    id: widget
                        .tugasItemLama['id'], 
                    judul: judulController.text,
                    deskripsi: deskripsiController.text,
                    kategori: kategoriTerpilih ?? "Lainnya",
                    dateline: "${tanggalController.text} ${jamController.text}",
                    status: widget.tugasItemLama['status'],
                  );

                  try {
                    // Panggil fungsi Update dari Controller
                    await TaskController().updateTugas(
                      widget.tugasItemLama['id'],
                      tugasUpdate,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tugas berhasil diedit 🚀"),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Yah gagal ngedit: $e")),
                    );
                  }
                },

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
