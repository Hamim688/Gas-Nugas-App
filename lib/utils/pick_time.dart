import 'package:flutter/material.dart';

// Fungsi 1: Khusus buat ngambil tanggal
Future<DateTime?> ambilTanggal(BuildContext context) async {
  DateTime? tanggal = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(), 
    lastDate: DateTime(2030),
  );

  // Balikin hasil tanggalnya ke halaman yang manggil
  return tanggal;
}

// Fungsi 2: Khusus buat ngambil jam
Future<TimeOfDay?> ambilJam(BuildContext context) async {
  TimeOfDay? jam = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  // Balikin hasil jamnya ke halaman yang manggil
  return jam;
}
