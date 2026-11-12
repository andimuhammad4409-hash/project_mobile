import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.onShowMessage,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<String> onShowMessage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
      children: [
        const Text('Pengaturan',
            style: TextStyle(
                color: deepPurple, fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: Theme.of(context).brightness == Brightness.dark
              ? null
              : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: const ListTile(
            contentPadding: EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 27,
              backgroundColor: Color(0xFF9B78E4),
              child: Text('P',
                  style: TextStyle(color: Colors.white, fontSize: 23)),
            ),
            title:
                Text('Purnama', style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('D0225027'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        const SizedBox(height: 13),
        Card(
          elevation: 0,
          color: Theme.of(context).brightness == Brightness.dark
              ? null
              : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Column(
            children: [
              _settingsTile(
                  Icons.info_outline,
                  'Tentang Aplikasi',
                  () => onShowMessage(
                      'ArsipKu - Aplikasi Arsip Digital versi 1.0')),
              const Divider(height: 1, indent: 55),
              _settingsTile(Icons.help_outline, 'Bantuan',
                  () => onShowMessage('Menu bantuan ArsipKu.')),
              const Divider(height: 1, indent: 55),
              _settingsTile(Icons.notifications_none, 'Notifikasi',
                  () => onShowMessage('Belum ada notifikasi baru.')),
              const Divider(height: 1, indent: 55),
              SwitchListTile(
                secondary:
                    const Icon(Icons.dark_mode_outlined, color: primaryPurple),
                title: const Text('Mode Gelap'),
                value: darkMode,
                activeColor: primaryPurple,
                onChanged: onDarkModeChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String title, VoidCallback onTap,
      {Color color = primaryPurple}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}