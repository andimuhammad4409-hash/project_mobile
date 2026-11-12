import 'package:flutter/material.dart';
import 'package:arsipku/pengaturan_dasar/tema_aplikasi.dart';
import 'package:arsipku/komponen/hiasan_gelombang.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF9F6FF), Color(0xFFE8DEFF)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -75,
            left: -40,
            right: -40,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(height: 250, color: const Color(0xFFD5C3FF)),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Container(
                      width: 190,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .52),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: const Icon(
                        Icons.folder_copy_rounded,
                        color: primaryPurple,
                        size: 112,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'ArsipKu',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: deepPurple,
                        letterSpacing: -.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Kelola dokumen penting\ndengan mudah dan rapi ✨',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF51456B),
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(flex: 2),
                    SizedBox(
                      width: 190,
                      child: FilledButton.icon(
                        onPressed: onStart,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('Mulai'),
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 42),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}