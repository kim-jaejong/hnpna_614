import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({super.key});

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                // 사용자가 텍스트를 입력
                labelText: 'Enter text to generate QR code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('Generate QR Code'),
            ),
            const SizedBox(height: 20),
            if (_controller.text.isNotEmpty)
              QrImageView(
                data: _controller.text,
                version: QrVersions.auto,
//                size: 100.0, // 지정하지 않으면 가장 작은 크기로  자동으로 크기 조정.
// option - final bool gapless;  If set to false, each of the squares in the QR code will have a small gap. Default is true.
              ),
          ],
        ),
      ),
    );
  }
}
