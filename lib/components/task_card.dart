import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proect_gas_nugas/pages/details_task.dart';
import 'package:proect_gas_nugas/utils/color_task.dart';
import 'package:proect_gas_nugas/utils/task_filter.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> tugasItem;

  const TaskCard({super.key, required this.tugasItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      elevation: 5,
      color: Color(0xFFEBF4F6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          // Bawa paket 'tugasItem' ke halaman DetailsTask
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsTask(tugasItem: tugasItem),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 10,
              height: 100,
              decoration: BoxDecoration(
                color: ColorTask.getColor(tugasItem["dateline"]),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tugasItem["judul"] ?? "Judul tidak tersedia",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 2),
                  Text(
                    DateFormat(
                      'yMMMMEEEEd',
                      'id_ID',
                    ).format(TaskFilter.parseTanggalLokal(tugasItem["dateline"])),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ColorTask.getColor(
                        tugasItem["dateline"],
                      ).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Text(
                      tugasItem["kategori"] ?? "Kategori tidak tersedia",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
