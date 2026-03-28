import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  final List<String> daftarkategori;
  final String categoryAktif;
  final Function(String) onCategoryChanged;

  const CategoryList({
    super.key,
    required this.daftarkategori,
    required this.categoryAktif,
    required this.onCategoryChanged
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          ...widget.daftarkategori.map((kategori) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: ChoiceChip(
                padding: EdgeInsets.symmetric(horizontal: 12),
                label: Text(kategori),
                selected: widget.categoryAktif == kategori,
                showCheckmark: false,
                onSelected: (bool selected) {
                  widget.onCategoryChanged(kategori);
                },
                selectedColor: Color(0xFF7AB2B2),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
                side: BorderSide(color: Color(0xFF088395), width: 1.5),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
