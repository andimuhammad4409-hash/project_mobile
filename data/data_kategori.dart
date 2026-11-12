import 'package:flutter/material.dart';

class CategoryInfo {
  const CategoryInfo(this.name, this.icon, this.background);

  final String name;
  final IconData icon;
  final Color background;

  static const List<CategoryInfo> defaultCategories = [
    CategoryInfo('Surat', Icons.mail_rounded, Color(0xFFEAE2FF)),
    CategoryInfo('Laporan', Icons.description_rounded, Color(0xFFDDF4EC)),
    CategoryInfo('Akademik', Icons.school_rounded, Color(0xFFE4EAFF)),
    CategoryInfo(
        'Administrasi', Icons.business_center_rounded, Color(0xFFE5EDFF)),
    CategoryInfo('Dokumen Lain', Icons.folder_rounded, Color(0xFFFFEBD6)),
    CategoryInfo('Lainnya', Icons.star_rounded, Color(0xFFFFF0D8)),
  ];

  static Color getCategoryColor(String category) {
    final found = defaultCategories.where((c) => c.name == category);
    if (found.isNotEmpty) return found.first.background;
    return const Color(0xFFFFEBD6);
  }

  static IconData getCategoryIcon(String category) {
    final found = defaultCategories.where((c) => c.name == category);
    if (found.isNotEmpty) return found.first.icon;
    return Icons.folder_rounded;
  }
}