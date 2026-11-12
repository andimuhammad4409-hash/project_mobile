import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/pengaturan_dasar/format_tanggal.dart';
import 'package:arsipku/data/data_kategori.dart';
import 'package:arsipku/data/data_dokumen.dart';

class DocumentFormScreen extends StatefulWidget {
  const DocumentFormScreen({super.key, this.document});

  final ArchiveDocument? document;

  @override
  State<DocumentFormScreen> createState() => _DocumentFormScreenState();
}

class _DocumentFormScreenState extends State<DocumentFormScreen> {
  late final TextEditingController name;
  late final TextEditingController description;
  late String category;
  late DateTime date;

  // Variabel state sementara khusus untuk tampilan UI lampiran
  String? selectedFileName;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.document?.name ?? '');
    description =
        TextEditingController(text: widget.document?.description ?? '');

    final availableNames =
        CategoryInfo.defaultCategories.map((c) => c.name).toList();
    final initialCat = widget.document?.category ?? availableNames.first;
    category = availableNames.contains(initialCat)
        ? initialCat
        : availableNames.first;

    date = widget.document?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    super.dispose();
  }

  // Simulasi pilihan file untuk melihat tampilan UI sebelum pasang file_picker
  void _simulasiPilihFile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final contohFile = [
          {'nama': 'Surat_Undangan_2026.pdf', 'ikon': Icons.picture_as_pdf, 'warna': Colors.red},
          {'nama': 'Scan_KTP_Pribadi.jpg', 'ikon': Icons.image, 'warna': Colors.blue},
          {'nama': 'Laporan_Keuangan.xlsx', 'ikon': Icons.table_chart, 'warna': Colors.green},
          {'nama': 'Draft_Proposal.docx', 'ikon': Icons.description, 'warna': Colors.indigo},
        ];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Simulasi Pilih File (Preview UI)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: deepPurple),
              ),
              const SizedBox(height: 12),
              ...contohFile.map((file) => ListTile(
                    leading: Icon(file['ikon'] as IconData, color: file['warna'] as Color),
                    title: Text(file['nama'] as String),
                    onTap: () {
                      setState(() => selectedFileName = file['nama'] as String);
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _save() {
    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dokumen wajib diisi.')),
      );
      return;
    }

    // Tetap kompatibel dengan konstruktor ArchiveDocument lama Anda
    final result = ArchiveDocument(
      name: name.text.trim(),
      number: '-',
      category: category,
      date: date,
      origin: selectedFileName ?? 'Tanpa lampiran',
      location: '-',
      description: description.text.trim(),
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.document != null;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEdit ? 'Edit Dokumen' : 'Tambah Dokumen'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 25),
          children: [
            Center(
              child: Container(
                width: 110,
                height: 105,
                decoration: BoxDecoration(
                  color: palePurple,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(Icons.post_add_rounded,
                    size: 65, color: primaryPurple),
              ),
            ),
            const SizedBox(height: 22),

            // 1. Nama Dokumen
            _fieldLabel('Nama Dokumen'),
            TextField(
              controller: name,
              decoration:
                  const InputDecoration(hintText: 'Contoh: Surat Undangan'),
            ),
            const SizedBox(height: 13),

            // 2. Kategori Dokumen
            _fieldLabel('Kategori Dokumen'),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(),
              items: CategoryInfo.defaultCategories
                  .map((item) => DropdownMenuItem(
                      value: item.name, child: Text(item.name)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => category = value);
              },
            ),
            const SizedBox(height: 13),

            // 3. Tanggal Dokumen
            _fieldLabel('Tanggal Dokumen'),
            OutlinedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => date = picked);
              },
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                side: const BorderSide(color: Color(0xFFE6E0F0)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month,
                      color: primaryPurple, size: 19),
                  const SizedBox(width: 10),
                  Text(formatDate(date),
                      style: const TextStyle(color: deepPurple)),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: deepPurple),
                ],
              ),
            ),
            const SizedBox(height: 13),

            // 4. Lampiran File (Tampilan UI)
            _fieldLabel('Upload File'),
            _buildKotakLampiran(),
            const SizedBox(height: 13),

            // 5. Keterangan
            _fieldLabel('Keterangan (Opsional)'),
            TextField(
              controller: description,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'Masukkan keterangan tambahan...'),
            ),
            const SizedBox(height: 22),

            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKotakLampiran() {
    return InkWell(
      onTap: _simulasiPilihFile,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palePurple.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: primaryPurple.withValues(alpha: 0.35),
            width: 1.3,
          ),
        ),
        child: selectedFileName == null
            ? const Column(
                children: [
                  Icon(Icons.upload_file_rounded,
                      size: 32, color: primaryPurple),
                  SizedBox(height: 6),
                  Text(
                    'Ketuk untuk upload file',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: deepPurple),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'PDF, JPG, PNG, DOCX, XLSX, PPTX',
                    style: TextStyle(fontSize: 11, color: Color(0xFF625879)),
                  ),
                ],
              )
            : Row(
                children: [
                  const Icon(Icons.insert_drive_file_rounded,
                      color: primaryPurple, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedFileName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: deepPurple),
                        ),
                        const Text(
                          'Ketuk untuk mengganti file',
                          style:
                              TextStyle(fontSize: 11, color: Color(0xFF625879)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.red),
                    onPressed: () {
                      setState(() => selectedFileName = null);
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(label,
          style: const TextStyle(
              color: deepPurple, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}