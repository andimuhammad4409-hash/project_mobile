import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/data/data_kategori.dart';
import 'package:arsipku/data/data_dokumen.dart';
import 'package:arsipku/komponen/kartu_dokumen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.docs,
    required this.searchQuery,
    required this.categoryFilter,
    required this.onSearchChanged,
    required this.onCategoryFilterChanged,
    required this.onOpenDetail,
    required this.onEditDocument,
    required this.onDeleteDocument,
  });

  final List<ArchiveDocument> docs;
  final String searchQuery;
  final String categoryFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryFilterChanged;
  final ValueChanged<ArchiveDocument> onOpenDetail;
  final ValueChanged<ArchiveDocument> onEditDocument;
  final ValueChanged<ArchiveDocument> onDeleteDocument;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterChips = [
      'Semua',
      ...CategoryInfo.defaultCategories.map((c) => c.name),
    ];

    final filtered = widget.docs.where((doc) {
      final q = widget.searchQuery.toLowerCase();
      // Mencari berdasarkan nama dokumen atau keterangan
      final matchesText = doc.name.toLowerCase().contains(q) ||
          doc.description.toLowerCase().contains(q);
      final matchesCategory = widget.categoryFilter == 'Semua' ||
          doc.category == widget.categoryFilter;
      return matchesText && matchesCategory;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
      children: [
        const Text('Cari Arsip',
            style: TextStyle(
                color: deepPurple, fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Cari nama dokumen...',
            prefixIcon: const Icon(Icons.search, color: primaryPurple),
            suffixIcon: widget.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 19),
                    onPressed: () {
                      _searchController.clear();
                      widget.onSearchChanged('');
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filterChips
                .map((item) => Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: ChoiceChip(
                        label: Text(item),
                        selected: widget.categoryFilter == item,
                        selectedColor: const Color(0xFFE5DAFF),
                        labelStyle: TextStyle(
                          color: widget.categoryFilter == item
                              ? deepPurple
                              : const Color(0xFF625879),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => widget.onCategoryFilterChanged(item),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 15),
        Text('${filtered.length} dokumen ditemukan',
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(28),
            child: Center(child: Text('Dokumen tidak ditemukan.')),
          ),
        ...filtered.map(
          (doc) => DocumentCard(
            doc: doc,
            onTap: () => widget.onOpenDetail(doc),
            onEdit: () => widget.onEditDocument(doc),
            onDelete: () => widget.onDeleteDocument(doc),
          ),
        ),
      ],
    );
  }
}