import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/pengaturan_dasar/format_tanggal.dart';
import 'package:arsipku/data/data_dokumen.dart';

class DocumentDetailScreen extends StatelessWidget {
  const DocumentDetailScreen({
    super.key,
    required this.doc,
    required this.onEdit,
    required this.onDelete,
  });

  final ArchiveDocument doc;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  // Helper kecil untuk menentukan ikon berdasarkan ekstensi file
  IconData _getFileIcon(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.pdf')) return Icons.picture_as_pdf_rounded;
    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png')) {
      return Icons.image_rounded;
    }
    if (lower.endsWith('.xls') || lower.endsWith('.xlsx')) {
      return Icons.table_chart_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    // Sementara membaca nama file dari doc.origin sebelum database diperbarui
    final hasFile = doc.origin.isNotEmpty &&
        doc.origin != '-' &&
        doc.origin != 'Tanpa lampiran';

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Dokumen')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 25),
        children: [
          // 1. Kartu Header Dokumen (Tanpa tanda '-' di bawah judul)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFFB99CEB), Color(0xFF7952C6)],
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.description_rounded,
                    size: 56, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  doc.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Kartu File Lampiran
          const Text(
            'File Dokumen',
            style: TextStyle(
              color: deepPurple,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: palePurple.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: primaryPurple.withValues(alpha: 0.3),
              ),
            ),
            child: hasFile
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getFileIcon(doc.origin),
                          color: primaryPurple,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.origin,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: deepPurple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Tersimpan di arsip lokal',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF625879),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Membuka pratinjau ${doc.origin}...'),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Buka'),
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Color(0xFF625879), size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Tidak ada file yang dilampirkan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF625879),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),

          // 3. Detail Informasi Inti
          _detailLine(
              Icons.category_outlined, 'Kategori Dokumen', doc.category),
          _detailLine(
              Icons.calendar_month, 'Tanggal Dokumen', formatDate(doc.date)),
          _detailLine(
            Icons.notes_rounded,
            'Keterangan',
            doc.description.isEmpty ? 'Tidak ada keterangan' : doc.description,
          ),
          const SizedBox(height: 24),

          // 4. Tombol Aksi Edit & Hapus
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  child: const Text('Hapus'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailLine(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: primaryPurple),
          const SizedBox(width: 12),
          SizedBox(
            width: 118,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: deepPurple,
              ),
            ),
          ),
          const Text(':  '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
