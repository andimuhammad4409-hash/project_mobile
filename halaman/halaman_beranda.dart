import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/data/data_kategori.dart';
import 'package:arsipku/data/data_dokumen.dart';
import 'package:arsipku/komponen/kartu_kategori.dart';
import 'package:arsipku/komponen/kartu_dokumen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.docs,
    required this.categories,
    required this.onSeeAllCategories,
    required this.onSeeAllDocuments,
    required this.onSelectCategory,
    required this.onOpenDetail,
    required this.onEditDocument,
    required this.onDeleteDocument,
  });

  final List<ArchiveDocument> docs;
  final List<CategoryInfo> categories;
  final VoidCallback onSeeAllCategories;
  final VoidCallback onSeeAllDocuments;
  final ValueChanged<String> onSelectCategory;
  final ValueChanged<ArchiveDocument> onOpenDetail;
  final ValueChanged<ArchiveDocument> onEditDocument;
  final ValueChanged<ArchiveDocument> onDeleteDocument;

  int _countCategory(String category) {
    return docs.where((d) => d.category == category).length;
  }

  @override
  Widget build(BuildContext context) {
    final visibleCategories = categories.take(4).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 90),
      children: [
        _totalArchiveCard(),
        const SizedBox(height: 22),
        _sectionHeader('Kategori', 'Lihat Semua', onSeeAllCategories),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 11,
            crossAxisSpacing: 11,
            childAspectRatio: 1.34,
          ),
          itemBuilder: (context, index) {
            final category = visibleCategories[index];
            return CategoryCard(
              category: category,
              count: _countCategory(category.name),
              onTap: () => onSelectCategory(category.name),
            );
          },
        ),
        const SizedBox(height: 20),
        _sectionHeader('Dokumen Terbaru', 'Lihat Semua', onSeeAllDocuments),
        const SizedBox(height: 8),
        ...docs.take(4).map(
              (doc) => DocumentCard(
                doc: doc,
                onTap: () => onOpenDetail(doc),
                onEdit: () => onEditDocument(doc),
                onDelete: () => onDeleteDocument(doc),
              ),
            ),
      ],
    );
  }

  Widget _totalArchiveCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(19, 18, 14, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC8B5F6), Color(0xFF8B69D4)],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withValues(alpha: .15),
            blurRadius: 15,
            offset: const Offset(0, 7),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Arsip',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(height: 5),
                Text(
                  '${docs.length} Dokumen',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.folder_copy_rounded, size: 62, color: Colors.white),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String action, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: deepPurple, fontSize: 16, fontWeight: FontWeight.w800)),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
              foregroundColor: primaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 4)),
          child: Row(
            children: [
              Text(action, style: const TextStyle(fontSize: 11)),
              const Icon(Icons.chevron_right, size: 17),
            ],
          ),
        ),
      ],
    );
  }
}