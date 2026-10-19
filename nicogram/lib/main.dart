import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NicoGramApp());
}

class NicoGramApp extends StatelessWidget {
  const NicoGramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'NicoGram',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  // URL backend FastAPI permanen di Pterodactyl Panel
  final String baseUrl = "http://144.79.202.196:40042";

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Peringatan'),
          content: const Text('Nomor telepon tidak boleh kosong'),
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
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/send_code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final phoneCodeHash = data['phone_code_hash'];

        if (!mounted) return;
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => OtpPage(
              phone: phone,
              phoneCodeHash: phoneCodeHash,
              baseUrl: baseUrl,
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body)['detail'] ?? 'Terjadi kesalahan';
        throw Exception(error);
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Koneksi Gagal'),
          content: Text('Tidak dapat terhubung ke server Python:\n$e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Nomor Telepon'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukkan nomor telepon akun Telegram Anda untuk masuk ke NicoGram.',
                style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('+62', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CupertinoTextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      placeholder: '88989612716',
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: _isLoading ? null : _sendCode,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : const Text('Lanjut', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Verifikasi Kode OTP (Gaya Cupertino)
class OtpPage extends StatefulWidget {
  final String phone;
  final String phoneCodeHash;
  final String baseUrl;

  const OtpPage({
    super.key,
    required this.phone,
    required this.phoneCodeHash,
    required this.baseUrl,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${widget.baseUrl}/api/sign_in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': widget.phone,
          'code': code,
          'phone_code_hash': widget.phoneCodeHash,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 'logged_in') {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => ChatPage(baseUrl: widget.baseUrl),
            ),
            (route) => false,
          );
        }
      } else {
        throw Exception(data['detail'] ?? 'Verifikasi gagal');
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('$e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Masukkan Kode OTP'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kode konfirmasi telah dikirim ke nomor ${widget.phone}',
                style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
              ),
              const SizedBox(height: 24),
              CupertinoTextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                placeholder: 'Kode OTP',
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: _isLoading ? null : _verifyCode,
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text('Verifikasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Utama / Daftar Pesan (Chat Page - Gaya Cupertino)
class ChatPage extends StatefulWidget {
  final String baseUrl;
  const ChatPage({super.key, required this.baseUrl});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(
        Uri.parse('${widget.baseUrl}/api/messages'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages = data['messages'] ?? [];
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat pesan');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Pesan Telegram'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.refresh),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            _fetchMessages();
          },
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator(radius: 16))
            : _messages.isEmpty
                ? const Center(child: Text('Tidak ada pesan ditemukan.'))
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return CupertinoListTile(
                        leading: const Icon(CupertinoIcons.person_circle, size: 40),
                        title: Text('Sender ID: ${msg['sender_id']}'),
                        subtitle: Text(msg['text'] ?? '[Media / Kosong]'),
                        additionalInfo: Text(
                          msg['date'].toString().split(' ').last.substring(0, 5),
                          style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
