import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/data/data_kategori.dart';
import 'package:arsipku/data/data_dokumen.dart';
import 'package:arsipku/halaman/halaman_kategori.dart';
import 'package:arsipku/halaman/halaman_beranda.dart';
import 'package:arsipku/halaman/detail_dokumen.dart';
import 'package:arsipku/halaman/form_dokumen.dart';
import 'package:arsipku/halaman/halaman_cari.dart';
import 'package:arsipku/halaman/halaman_profil.dart';

class ArchiveShell extends StatefulWidget {
  const ArchiveShell({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<ArchiveShell> createState() => _ArchiveShellState();
}

class _ArchiveShellState extends State<ArchiveShell> {
  int currentTab = 0;
  String searchQuery = '';
  String categoryFilter = 'Semua';

  final List<ArchiveDocument> docs = [
    ArchiveDocument(
      name: 'Surat Undangan',
      number: 'No. 001/UND/2025',
      category: 'Surat',
      date: DateTime(2025, 10, 27),
      origin: 'Rektorat',
      location: 'Loker 1',
      description: 'Undangan kegiatan kampus',
    ),
    ArchiveDocument(
      name: 'Laporan Kegiatan',
      number: 'No. 012/LAP/2025',
      category: 'Laporan',
      date: DateTime(2025, 10, 25),
      origin: 'Bagian Kemahasiswaan',
      location: 'Loker 2',
      description: 'Laporan kegiatan mahasiswa',
    ),
    ArchiveDocument(
      name: 'Surat Keluar',
      number: 'No. 045/SK/2025',
      category: 'Surat',
      date: DateTime(2025, 10, 20),
      origin: 'Administrasi',
      location: 'Loker 1',
      description: 'Dokumen surat keluar',
    ),
    ArchiveDocument(
      name: 'Dokumen Akademik',
      number: 'No. 078/AKD/2025',
      category: 'Akademik',
      date: DateTime(2025, 10, 18),
      origin: 'Akademik',
      location: 'Loker 3',
      description: 'Arsip akademik',
    ),
  ];

  final List<CategoryInfo> categories = CategoryInfo.defaultCategories;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        docs: docs,
        categories: categories,
        onSeeAllCategories: () => setState(() => currentTab = 2),
        onSeeAllDocuments: () {
          setState(() {
            categoryFilter = 'Semua';
            currentTab = 1;
          });
        },
        onSelectCategory: (catName) {
          setState(() {
            categoryFilter = catName;
            currentTab = 1;
          });
        },
        onOpenDetail: _openDetail,
        onEditDocument: (doc) => _openDocumentForm(document: doc),
        onDeleteDocument: _deleteDocument,
      ),
      SearchScreen(
        docs: docs,
        searchQuery: searchQuery,
        categoryFilter: categoryFilter,
        onSearchChanged: (val) => setState(() => searchQuery = val),
        onCategoryFilterChanged: (val) => setState(() => categoryFilter = val),
        onOpenDetail: _openDetail,
        onEditDocument: (doc) => _openDocumentForm(document: doc),
        onDeleteDocument: _deleteDocument,
      ),
      CategoriesScreen(
        docs: docs,
        categories: categories,
        onSelectCategory: (catName) {
          setState(() {
            categoryFilter = catName;
            currentTab = 1;
          });
        },
      ),
      SettingsScreen(
        darkMode: widget.darkMode,
        onDarkModeChanged: widget.onDarkModeChanged,
        onShowMessage: _snack,
      ),
    ];

    return Scaffold(
    appBar: currentTab == 0
          ? AppBar(
              title: const Row(
                children: [
                  Icon(Icons.folder_copy_rounded, color: primaryPurple, size: 26),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ArsipKu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: deepPurple,
                        ),
                      ),
                      Text(
                        'Penyimpanan Dokumen Lokal',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF625879),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
      body: SafeArea(child: pages[currentTab]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDocumentForm(),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark
            ? null
            : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navButton(0, Icons.home_rounded, 'Beranda'),
              _navButton(1, Icons.search_rounded, 'Cari'),
              const SizedBox(width: 48),
              _navButton(2, Icons.grid_view_rounded, 'Kategori'),
              _navButton(3, Icons.person_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(int index, IconData icon, String label) {
    final active = currentTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          if (index == 1 && currentTab != 1) {
            categoryFilter = 'Semua';
          }
          currentTab = index;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 67,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 22,
                color: active ? primaryPurple : const Color(0xFF9991AA)),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: active ? primaryPurple : const Color(0xFF9991AA),
                fontWeight: active ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDocumentForm({ArchiveDocument? document}) async {
    final result = await Navigator.push<ArchiveDocument>(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentFormScreen(document: document),
      ),
    );

    if (result != null) {
      setState(() {
        if (document == null) {
          docs.insert(0, result);
        } else {
          final index = docs.indexOf(document);
          if (index != -1) docs[index] = result;
        }
      });
      _snack(document == null
          ? 'Dokumen berhasil ditambahkan.'
          : 'Dokumen berhasil diperbarui.');
    }
  }

  void _openDetail(ArchiveDocument doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentDetailScreen(
          doc: doc,
          onEdit: () => _openDocumentForm(document: doc),
          onDelete: () => _deleteDocument(doc),
        ),
      ),
    );
  }

  void _deleteDocument(ArchiveDocument doc) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Dokumen'),
        content: Text('Hapus "${doc.name}" dari daftar arsip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => docs.remove(doc));
              Navigator.pop(dialogContext);
              _snack('Dokumen berhasil dihapus.');
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}