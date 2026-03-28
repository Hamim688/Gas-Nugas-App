class TaskFilter {
  static List<Map<String, dynamic>> filterByTab({
    required List<Map<String, dynamic>> semuaTugas,
    required String kategoriAktif,
    required String tipeTab, // "menunggu", "selesai", atau "terlambat"
  }) {
    // Kita pakai .where() di sini, bukan di UI
    return semuaTugas.where((tugasItem) {
      // 1. FILTER KATEGORI
      if (kategoriAktif != "Semua" && tugasItem["kategori"] != kategoriAktif) {
        return false;
      }

      // 2. LOGIKA TANGGAL & STATUS
      bool isSelesai = tugasItem["status"] == true;

      DateTime deadline = parseTanggalLokal(tugasItem["dateline"]);
      DateTime now = DateTime.now();

      // Normalisasi tanggal (jam 00:00) biar fair
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime deadlineDate = DateTime(
        deadline.year,
        deadline.month,
        deadline.day,
      );

      // Cek terlambat (Deadline < Hari Ini)
      bool isTerlambat = deadlineDate.isBefore(today);

      // 3. LOGIKA TAB
      if (tipeTab == "selesai") {
        return isSelesai;
      } else if (tipeTab == "terlambat") {
        return !isSelesai && isTerlambat;
      } else {
        // Tab "menunggu" (Belum selesai DAN Belum terlambat)
        return !isSelesai && !isTerlambat;
      }
    }).toList();
  }

  static DateTime parseTanggalLokal(String tgl) {
    try {
      return DateTime.parse(tgl);
    } catch (e) {
      List<String> bagian = tgl.split(' ');
      List<String> tglBagian = bagian[0].split('/');
      int hari = int.parse(tglBagian[0]);
      int bulan = int.parse(tglBagian[1]);
      int tahun = int.parse(tglBagian[2]);
      return DateTime(tahun, bulan, hari);
    }
  }
}
