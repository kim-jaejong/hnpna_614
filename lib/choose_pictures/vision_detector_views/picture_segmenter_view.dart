import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'detector_view.dart';
import 'package:google_mlkit_selfie_segmentation/google_mlkit_selfie_segmentation.dart';
import 'segmentation_painter.dart';

class PictureSegmenterView extends StatefulWidget {
  const PictureSegmenterView({super.key});

  @override
  State<PictureSegmenterView> createState() => _PictureSegmenterViewState();
}

class _PictureSegmenterViewState extends State<PictureSegmenterView> {
  final SelfieSegmenter _segmenter = SelfieSegmenter(
    mode: SegmenterMode.single, //하나의 사진만 처리
    enableRawSizeMask: true,
  );

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void dispose() async {
    _canProcess = false;
    _segmenter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
        title: 'Picture Segmenter',
        customPaint: _customPaint,
        text: _text,
        onImage: _processImage,
        initialDetectionMode: DetectorViewMode.gallery);
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final mask = await _segmenter.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null &&
        mask != null) {
      final painter = SegmentationPainter(mask, inputImage.metadata!.size,
          inputImage.metadata!.rotation, CameraLensDirection.front);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text =
          'There is a mask with ${(mask?.confidences ?? []).where((element) => element > 0.8).length} elements';
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
