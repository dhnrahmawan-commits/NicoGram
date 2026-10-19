import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

void main() {
  runApp(const NicoGramApp());
}

class NicoGramApp extends StatefulWidget {
  const NicoGramApp({super.key});

  @override
  State<NicoGramApp> createState() => _NicoGramAppState();
}

class _NicoGramAppState extends State<NicoGramApp> {
  bool isDarkMode = true;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'NicoGram',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: CupertinoColors.activeBlue,
        scaffoldBackgroundColor: isDarkMode ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
        barBackgroundColor: isDarkMode ? const Color(0xFF1C1C1E) : const Color(0xFFF9F9F9),
      ),
      home: const NicoLoginScreen(),
    );
  }
}

// ==========================================================================
// 1. HALAMAN LOGIN NICO (API ID & HASH CONFIG)
// ==========================================================================
class NicoLoginScreen extends StatefulWidget {
  const NicoLoginScreen({super.key});

  @override
  State<NicoLoginScreen> createState() => _NicoLoginScreenState();
}

class _NicoLoginScreenState extends State<NicoLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final int apiId = 22162857;
  final String apiHash = "e735f9e5b843d626e18195a843c5e625";

  bool isLoading = false;

  void _handleLogin() async {
    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
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

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => NicoOtpScreen(phoneNumber: "+62$phoneNumber"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Nomor Telepon', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isLoading ? null : _handleLogin,
          child: isLoading 
            ? const CupertinoActivityIndicator() 
            : const Text('Lanjut', style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold)),
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
                  color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Text('Indonesia', style: TextStyle(fontSize: 18)),
                        ),
                        const Spacer(),
                        const Text('+62', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 18)),
                        const SizedBox(width: 16),
                      ],
                    ),
                    Container(height: 0.5, color: CupertinoColors.separator, margin: const EdgeInsets.only(left: 16)),
                    CupertinoTextField(
                      controller: _phoneController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      placeholder: '81234567890',
                      placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 18),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18),
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
// 2. HALAMAN KODE OTP
// ==========================================================================
class NicoOtpScreen extends StatelessWidget {
  final String phoneNumber;
  const NicoOtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Kode Verifikasi'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                'Masukkan kode konfirmasi yang dikirim ke Telegram pada nomor\n$phoneNumber',
                textAlign: TextAlign.center,
                style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 15),
              ),
              const SizedBox(height: 30),
              CupertinoTextField(
                padding: const EdgeInsets.all(14),
                placeholder: 'Masukkan Kode OTP',
                placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
                style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text('Masuk ke NicoGram'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => const NicoMainScreen()),
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
// 3. MENU UTAMA (TAB BAR BAWAH: CHATS, CALLS, CONTACTS, SETTINGS)
// ==========================================================================
class NicoMainScreen extends StatelessWidget {
  const NicoMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2_fill), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.phone_fill), label: 'Calls'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_2_fill), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
        ],
      ),
      tabBuilder: (context, index) {
        if (index == 0) return const NicoChatListScreen();
        if (index == 1) return const NicoCallsScreen();
        if (index == 2) return const NicoContactsScreen();
        return const NicoSettingsScreen();
      },
    );
  }
}

// ==========================================================================
// 4. CHAT LIST SCREEN (DENGAN PENCARIAN INTERAKTIF)
// ==========================================================================
class NicoChatListScreen extends StatefulWidget {
  const NicoChatListScreen({super.key});

  @override
  State<NicoChatListScreen> createState() => _NicoChatListScreenState();
}

class _NicoChatListScreenState extends State<NicoChatListScreen> {
  String searchQuery = "";

  final List<Map<String, String>> allChats = [
    {
      'name': 'NicoGram Official • @wNakama',
      'message': 'API ID: 22162857 terkonfigurasi dengan sukses!',
      'time': 'Baru saja',
      'unread': '1',
    },
    {
      'name': 'Cloud Storage',
      'message': 'Simpan file konfigurasi bot Telegram di sini.',
      'time': 'Kemarin',
      'unread': '',
    },
    {
      'name': 'Saluran Informasi Android',
      'message': 'Update sistem operasi versi terbaru dirilis.',
      'time': '18 Okt',
      'unread': '3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    
    final filteredChats = allChats.where((chat) {
      return chat['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
             chat['message']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Edit', style: TextStyle(color: CupertinoColors.activeBlue)),
          onPressed: () {},
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.square_pencil, color: CupertinoColors.activeBlue),
          onPressed: () {},
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSearchTextField(
                placeholder: 'Search chats or messages',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredChats.length,
                itemBuilder: (context, index) {
                  final chat = filteredChats[index];
                  return _buildChatItem(
                    context,
                    name: chat['name']!,
                    message: chat['message']!,
                    time: chat['time']!,
                    unreadCount: chat['unread']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => NicoChatRoomScreen(chatTitle: chat['name']!)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, {required String name, required String message, required String time, required String unreadCount, required VoidCallback onTap}) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(CupertinoIcons.paperplane_fill, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
                      Text(time, style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 14)),
                      ),
                      if (unreadCount.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(unreadCount, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================================
// 5. CHAT ROOM SCREEN (KIRIM PESAN INTERAKTIF)
// ==========================================================================
class NicoChatRoomScreen extends StatefulWidget {
  final String chatTitle;
  const NicoChatRoomScreen({super.key, required this.chatTitle});

  @override
  State<NicoChatRoomScreen> createState() => _NicoChatRoomScreenState();
}

class _NicoChatRoomScreenState extends State<NicoChatRoomScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List<String> messages = [
    "Selamat datang di NicoGram! Antarmuka iOS dan konfigurasi API ID sudah aktif sepenuhnya."
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      messages.add(_msgController.text.trim());
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.chatTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isMe = index % 2 != 0;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 290),
                      decoration: BoxDecoration(
                        color: isMe ? CupertinoColors.activeBlue : const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(messages[index], style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.systemGrey6,
              child: Row(
                children: [
                  const Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CupertinoTextField(
                      controller: _msgController,
                      placeholder: 'Message',
                      placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black : CupertinoColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _sendMessage,
                    child: const Icon(CupertinoIcons.arrow_up_circle_fill, color: CupertinoColors.activeBlue, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================================
// 6. CALLS SCREEN
// ==========================================================================
class NicoCallsScreen extends StatelessWidget {
  const NicoCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Calls', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ),
      child: SafeArea(
        child: ListView(
          children: const [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text('Belum ada riwayat panggilan masuk atau keluar.', style: TextStyle(color: CupertinoColors.systemGrey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================================
// 7. CONTACTS SCREEN
// ==========================================================================
class NicoContactsScreen extends StatelessWidget {
  const NicoContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue),
          onPressed: () {},
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            _buildContactRow('Nico Developer', '@wNakama', isDark),
            _buildContactRow('Telegram Support', '@support', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(String name, String username, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: CupertinoColors.activeBlue, borderRadius: BorderRadius.circular(22)),
            child: const Icon(CupertinoIcons.person_fill, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
              const SizedBox(height: 2),
              Text(username, style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// 8. SETTINGS SCREEN (PENGATURAN LENGKAP & DEVELOPER INFO)
// ==========================================================================
class NicoSettingsScreen extends StatelessWidget {
  const NicoSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Pengaturan Nico', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
                  const Text('NicoGram', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Mod by @wNakama', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(CupertinoIcons.moon_fill, color: CupertinoColors.activeBlue, size: 22),
                        SizedBox(width: 14),
                        Text('Mode Gelap (Dark Mode)', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    CupertinoSwitch(
                      value: isDark,
                      activeColor: CupertinoColors.activeBlue,
                      onChanged: (bool value) {
                        context.findAncestorStateOfType<_NicoGramAppState>()?.toggleTheme(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
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
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
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
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
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
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          Text(detail, style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 15)),
          const SizedBox(width: 6),
          const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey, size: 18),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(margin: const EdgeInsets.only(left: 52), height: 0.5, color: CupertinoColors.separator);
  }
}
