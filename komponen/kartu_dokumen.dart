import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/pengaturan_dasar/format_tanggal.dart';
import 'package:arsipku/data/data_kategori.dart';
import 'package:arsipku/data/data_dokumen.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.doc,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final ArchiveDocument doc;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .7,
      shadowColor: const Color(0x16000000),
      color: Theme.of(context).brightness == Brightness.dark
          ? null
          : Colors.white,
      margin: const EdgeInsets.only(bottom: 9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: CategoryInfo.getCategoryColor(doc.category),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            CategoryInfo.getCategoryIcon(doc.category),
            color: primaryPurple,
          ),
        ),
        title: Text(
          doc.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            formatDate(doc.date),
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF625879)),
          ),
        ),
        onTap: onTap,
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Hapus')),
          ],
        ),
      ),
    );
  }
}