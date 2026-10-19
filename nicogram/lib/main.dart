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
      // Halaman pertama yang dibuka sekarang adalah Login
      home: NicoLoginScreen(),
    );
  }
}

// ==========================================================================
// HALAMAN LOGIN NICO (UI iOS)
// ==========================================================================
class NicoLoginScreen extends StatefulWidget {
  const NicoLoginScreen({super.key});

  @override
  State<NicoLoginScreen> createState() => _NicoLoginScreenState();
}

class _NicoLoginScreenState extends State<NicoLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

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
          child: const Text('Lanjut', style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold)),
          onPressed: () {
            // Simulasi pindah ke halaman chat setelah klik Lanjut
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) => const NicoChatRoomScreen()),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Silakan konfirmasi kode negara dan masukkan nomor telepon Anda.',
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
                    // Baris Kode Negara
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
                    // Baris Input Nomor
                    CupertinoTextField(
                      controller: _phoneController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      placeholder: 'Nomor telepon',
                      placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 18),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      keyboardType: TextInputType.phone,
                      decoration: const BoxDecoration(color: Colors.transparent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sinkronisasi Kontak', style: TextStyle(color: Colors.white, fontSize: 16)),
                  CupertinoSwitch(
                    value: true,
                    activeColor: CupertinoColors.activeBlue,
                    onChanged: (bool value) {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// HALAMAN CHAT (RUANG OBROLAN)
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
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.phone, color: CupertinoColors.activeBlue),
          onPressed: () {},
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              children: [
                _buildChatBubble(
                  message: "Halo! Selamat datang di NicoGram buatan @wNakama.",
                  isMe: false,
                  onLongPress: (posY) {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      isHoldingMessage = true;
                      activeMessageText = "Halo! Selamat datang di NicoGram buatan @wNakama.";
                      messagePosY = posY;
                    });
                  },
                ),
                _buildChatBubble(
                  message: "Ketuk ikon roda gigi di pojok kiri atas untuk membuka Pengaturan Nico & melihat informasi pembuat!",
                  isMe: true,
                  onLongPress: (posY) {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      isHoldingMessage = true;
                      activeMessageText = "Ketuk ikon roda gigi di pojok kiri atas untuk membuka Pengaturan Nico & melihat informasi pembuat!";
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _buildMenuRow('Reply', CupertinoIcons.reply),
                          const Divider(color: Color(0xFF3A3A3C), height: 10),
                          _buildMenuRow('Copy', CupertinoIcons.doc_on_doc),
                          const Divider(color: Color(0xFF3A3A3C), height: 10),
                          _buildMenuRow('Forward', CupertinoIcons.share),
                          const Divider(color: Color(0xFF3A3A3C), height: 10),
                          _buildMenuRow('Delete', CupertinoIcons.delete, isRed: true),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        activeMessageText,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
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
      onLongPressStart: (details) {
        onLongPress(details.globalPosition.dy);
      },
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
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuRow(String title, IconData icon, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: isRed ? CupertinoColors.systemRed : Colors.white, fontSize: 15)),
          Icon(icon, color: isRed ? CupertinoColors.systemRed : Colors.white, size: 18),
        ],
      ),
    );
  }
}

// ==========================================================================
// HALAMAN PENGATURAN NICO (SETTINGS)
// ==========================================================================
class NicoSettingsScreen extends StatelessWidget {
  const NicoSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xFF1C1C1E),
        middle: Text(
          'Pengaturan Nico',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
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
                  const Text('Mod by @wNakama', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildSettingRow(CupertinoIcons.settings, 'Pengaturan Umum', () {}),
                  _buildDivider(),
                  _buildSettingRow(CupertinoIcons.paintbrush, 'Tampilan & Tema', () {}),
                  _buildDivider(),
                  _buildSettingRow(CupertinoIcons.chat_bubble_2, 'Obrolan', () {}),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildSettingRowWithDetail(CupertinoIcons.news, 'CH Official', '@NicogramInfo'),
                  _buildDivider(),
                  _buildSettingRowWithDetail(CupertinoIcons.person_crop_circle, 'Contact Developer', '@wNakama'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Column(
                  children: [
                    const Text('NicoGram v1.0.0 (7112) arm64-v8a', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text('Berdasarkan Telegram v12.10.6\nDibuat oleh @wNakama', textAlign: TextAlign.center, style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String title, VoidCallback onTap) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.activeBlue, size: 22),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))),
          const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey, size: 18),
        ],
      ),
    );
  }

  Widget _buildSettingRowWithDetail(IconData icon, String title, String detail) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: () {},
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.activeBlue, size: 22),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))),
          Text(detail, style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 15)),
          const SizedBox(width: 6),
          const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey, size: 18),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(margin: const EdgeInsets.only(left: 52), height: 0.5, color: const Color(0xFF3A3A3C));
  }
}
