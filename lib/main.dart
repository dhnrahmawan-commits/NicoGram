import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk efek getar (Haptic Feedback)

void main() {
  runApp(const TelegramIOSApp());
}

class TelegramIOSApp extends StatelessWidget {
  const TelegramIOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Telegram iOS Style',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.activeBlue,
        scaffoldBackgroundColor: Color(0xFF000000), // Hitam pekat khas Telegram iOS Dark Mode
        barBackgroundColor: Color(0xFF1C1C1E),
      ),
      home: IOSChatRoomScreen(),
    );
  }
}

class IOSChatRoomScreen extends StatefulWidget {
  const IOSChatRoomScreen({super.key});

  @override
  State<IOSChatRoomScreen> createState() => _IOSChatRoomScreenState();
}

class _IOSChatRoomScreenState extends State<IOSChatRoomScreen> {
  // Variabel untuk mengontrol status "long press" pada bubble chat
  bool isHoldingMessage = false;
  String activeMessageText = "";
  double messagePosY = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // Navigation Bar atas ala Telegram iOS
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E).withOpacity(0.9),
        middle: const Text(
          'Telegram iOS',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
          onPressed: () {},
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
            // 1. DAFTAR RUANG OBROLAN (CHAT BUBBLES)
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              children: [
                _buildChatBubble(
                  message: "Halo! Ini adalah uji coba tampilan chat mirip iPhone dengan efek blur.",
                  isMe: false,
                  onLongPress: (posY) {
                    // Memberikan efek getar halus khas Taptic Engine iPhone
                    HapticFeedback.mediumImpact();
                    setState(() {
                      isHoldingMessage = true;
                      activeMessageText = "Halo! Ini adalah uji coba tampilan chat mirip iPhone dengan efek blur.";
                      messagePosY = posY;
                    });
                  },
                ),
                _buildChatBubble(
                  message: "Tahan gelembung pesan ini untuk melihat efek latarnya jadi blur dan menu pop-up melayang.",
                  isMe: true,
                  onLongPress: (posY) {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      isHoldingMessage = true;
                      activeMessageText = "Tahan gelembung pesan ini untuk melihat efek latarnya jadi blur dan menu pop-up melayang.";
                      messagePosY = posY;
                    });
                  },
                ),
              ],
            ),

            // 2. EFEK BLUR LATAR BELAKANG & MENU KONTEKS (MUNCUL SAAT LONG PRESS)
            if (isHoldingMessage) ...[
              // Lapisan Blur Real-Time (Meniru UIVisualEffectView iOS)
              GestureDetector(
                onTap: () {
                  // Menutup menu dan menghilangkan blur saat area luar ditekan
                  setState(() {
                    isHoldingMessage = false;
                  });
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.45), // Gelap transparan khas iOS
                  ),
                ),
              ),

              // 3. MENU MELAYANG & GELEMBUNG PESAN YANG DIANGKAT
              Positioned(
                top: messagePosY > 200 ? messagePosY - 140 : 100,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Menu Pop-up Aksi (Reply, Copy, Forward, Delete) ala Telegram iOS
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

                    // Gelembung Pesan yang Dipilih (Tampak Melayang di Atas Blur)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF), // Warna biru khas gelembung chat iOS
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

  // Widget Komponen Gelembung Chat Individual
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

  // Widget Baris Menu Pop-up
  Widget _buildMenuRow(String title, IconData icon, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isRed ? CupertinoColors.systemRed : Colors.white,
              fontSize: 15,
            ),
          ),
          Icon(
            icon,
            color: isRed ? CupertinoColors.systemRed : Colors.white,
            size: 18,
          ),
        ],
      ),
    );
  }
}
