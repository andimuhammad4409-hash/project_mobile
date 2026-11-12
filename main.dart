import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/halaman/menu_utama.dart';
//import 'package:arsipku/halaman/halaman_awal.dart';

void main() => runApp(const ArsipKuApp());

class ArsipKuApp extends StatefulWidget {
  const ArsipKuApp({super.key});

  @override
  State<ArsipKuApp> createState() => _ArsipKuAppState();
}

class _ArsipKuAppState extends State<ArsipKuApp> {
  bool darkMode = false;
  bool isStarted = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArsipKu',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: ArchiveShell(
        darkMode: darkMode,
        onDarkModeChanged: (value) {
          setState(() => darkMode = value);
        },
      ),
    );
  }
}