import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/data/data_kategori.dart';
import 'package:arsipku/data/data_dokumen.dart';
import 'package:arsipku/komponen/kartu_kategori.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    required this.docs,
    required this.categories,
    required this.onSelectCategory,
  });

  final List<ArchiveDocument> docs;
  final List<CategoryInfo> categories;
  final ValueChanged<String> onSelectCategory;

  int _countCategory(String category) {
    return docs.where((d) => d.category == category).length;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
      children: [
        const Text('Kategori Dokumen',
            style: TextStyle(
                color: deepPurple, fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 17),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 13,
            crossAxisSpacing: 13,
            childAspectRatio: 1.16,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              count: _countCategory(category.name),
              onTap: () => onSelectCategory(category.name),
            );
          },
        ),
      ],
    );
  }
}