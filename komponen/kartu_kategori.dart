import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/data/data_kategori.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.count,
    required this.onTap,
  });

  final CategoryInfo category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        decoration: BoxDecoration(
          color: category.background,
          borderRadius: BorderRadius.circular(17),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 31, color: primaryPurple),
            const SizedBox(height: 7),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: deepPurple,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            Text(
              '($count)',
              style: const TextStyle(color: Color(0xFF625879), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}