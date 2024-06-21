import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class FlowerIdentifier extends StatefulWidget {
  const FlowerIdentifier({super.key});

  @override
  State<FlowerIdentifier> createState() => _FlowerIdentifierState();
}

class _FlowerIdentifierState extends State<FlowerIdentifier> {
  final ImagePicker _picker = ImagePicker();
  String _flowerName = 'No flower identified yet';

  Future<void> _takePhoto() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      final inputImage = InputImage.fromFilePath(file.path);
      final imageLabeler =
          ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.7));

      final labels = await imageLabeler.processImage(inputImage);
      imageLabeler.close();

      String flowerName = 'Unknown flower';
      for (final label in labels) {
        if (label.label.toLowerCase().contains('flower')) {
          flowerName = label.label;
          break;
        }
      }

      setState(() {
        _flowerName = flowerName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flower Identifier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera),
            onPressed: _takePhoto,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _flowerName,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePhoto,
              child: const Text('Take a Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
