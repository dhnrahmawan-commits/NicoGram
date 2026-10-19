import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

void main() {
  runApp(const NicoGramApp());
}

class NicoGramApp extends StatelessWidget {
  const NicoGramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'NicoGram',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.activeBlue,
        scaffoldBackgroundColor: Color(0xFF000000),
        barBackgroundColor: Color(0xFF1C1C1E),
      ),
      home: NicoLoginScreen(),
    );
  }
}

// ==========================================================================
// HALAMAN LOGIN NICO (DENGAN KUNCI API TELEGRAM)
// ==========================================================================
class NicoLoginScreen extends StatefulWidget {
  const NicoLoginScreen({super.key});

  @override
  State<NicoLoginScreen> createState() => _NicoLoginScreenState();
}

class _NicoLoginScreenState extends State<NicoLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  // Kunci API Telegram Anda
  final int apiId = 22162857;
  final String apiHash = "e735f9e5b843d626e18195a843c5e625";

  void _handleLogin() {
    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      // Peringatan jika nomor kosong
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Perhatian'),
          content: const Text('Silakan masukkan nomor telepon terlebih dahulu.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    // Jika nomor terisi, lanjut ke Halaman Verifikasi OTP
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => NicoOtpScreen(phoneNumber: "+62$phoneNumber"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E).withOpacity(0.9),
        middle: const Text(
          'Nomor Telepon',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _handleLogin,
          child: const Text('Lanjut', style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Masukkan nomor telepon akun Telegram Anda untuk masuk ke NicoGram.',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Text('Indonesia', style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                        const Spacer(),
                        const Text('+62', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 18)),
                        const SizedBox(width: 16),
                      ],
                    ),
                    Container(height: 0.5, color: const Color(0xFF3A3A3C), margin: const EdgeInsets.only(left: 16)),
                    CupertinoTextField(
                      controller: _phoneController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      placeholder: '81234567890',
                      placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 18),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      keyboardType: TextInputType.phone,
                      decoration: const BoxDecoration(color: Colors.transparent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// HALAMAN KODE OTP (VERIFIKASI TELEGRAM)
// ==========================================================================
class NicoOtpScreen extends StatelessWidget {
  final String phoneNumber;
  const NicoOtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xFF1C1C1E),
        middle: Text('Kode Verifikasi', style: TextStyle(color: Colors.white)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                'Kode konfirmasi telah dikirim ke aplikasi Telegram Anda di nomor\n$phoneNumber',
                textAlign: TextAlign.center,
                style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 15),
              ),
              const SizedBox(height: 30),
              CupertinoTextField(
                padding: const EdgeInsets.all(14),
                placeholder: 'Masukkan Kode OTP',
                placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text('Masuk ke NicoGram'),
                onPressed: () {
                  // Setelah OTP dimasukkan, langsung masuk ke Ruang Obrolan
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => const NicoChatRoomScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// HALAMAN CHAT (RUANG OBROLAN) & PENGATURAN (SAMA SEBELUMNYA)
// ==========================================================================
class NicoChatRoomScreen extends StatefulWidget {
  const NicoChatRoomScreen({super.key});

  @override
  State<NicoChatRoomScreen> createState() => _NicoChatRoomScreenState();
}

class _NicoChatRoomScreenState extends State<NicoChatRoomScreen> {
  bool isHoldingMessage = false;
  String activeMessageText = "";
  double messagePosY = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E).withOpacity(0.9),
        middle: const Text(
          'NicoGram • Mod by @wNakama',
          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.settings, color: CupertinoColors.activeBlue),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const NicoSettingsScreen()),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              children: [
                _buildChatBubble(
                  message: "Berhasil masuk dengan API ID: 22162857! Selamat datang di NicoGram buatan @wNakama.",
                  isMe: false,
                  onLongPress: (posY) {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      isHoldingMessage = true;
                      activeMessageText = "Berhasil masuk dengan API ID: 22162857! Selamat datang di NicoGram buatan @wNakama.";
                      messagePosY = posY;
                    });
                  },
                ),
              ],
            ),
            if (isHoldingMessage) ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    isHoldingMessage = false;
                  });
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(color: Colors.black.withOpacity(0.45)),
                ),
              ),
              Positioned(
                top: messagePosY > 200 ? messagePosY - 140 : 100,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(activeMessageText, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble({required String message, required bool isMe, required Function(double) onLongPress}) {
    return GestureDetector(
      onLongPressStart: (details) => onLongPress(details.globalPosition.dy),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 270),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF007AFF) : const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}

class NicoSettingsScreen extends StatelessWidget {
  const NicoSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xFF1C1C1E),
        middle: Text('Pengaturan Nico', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: const Color(0xFF007AFF), borderRadius: BorderRadius.circular(40)),
                    child: const Icon(CupertinoIcons.paperplane_fill, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text('NicoGram', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Mod by @wNakama (API Configured)', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
