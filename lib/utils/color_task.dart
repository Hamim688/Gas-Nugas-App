import 'package:flutter/material.dart';
import 'package:proect_gas_nugas/utils/task_filter.dart';

class ColorTask {
  static Color getColor(String dateString) {
    // Ambil data
    DateTime deadline = TaskFilter.parseTanggalLokal(dateString);
    // Ambil data sekarang
    DateTime hariIni = DateTime.now();
    // Hitung Selisih
    int sisaHari = deadline.difference(hariIni).inDays;

    if (sisaHari < 0) {
      // Untuk TUgas Terlambat
      return Color(0xFF361212); 
    } else if (sisaHari <= 3) {
      // Udah Mepet Dateline
      return Color(0xFFE60000);
    } else if (sisaHari <= 7) {
      // Tugas yang akan dateline dalam 1 minggu
      return Color(0xFFE6A900);
    } else {
      return Color(0xFF46C90A); // Hijau untuk tugas yang masih jauh
    }
  }
}