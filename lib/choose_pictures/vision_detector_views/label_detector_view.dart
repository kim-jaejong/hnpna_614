import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'detector_view.dart';
import 'painter/label_detector_painter.dart';
import '../../utils/utils.dart';

class ImageLabelView extends StatefulWidget {
  const ImageLabelView({super.key});

  @override
  State<ImageLabelView> createState() => _ImageLabelViewState();
}

class _ImageLabelViewState extends State<ImageLabelView> {
  late ImageLabeler _imageLabeler;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void initState() {
    super.initState();

    _initializeLabeler();
  }

  @override
  void dispose() {
    _canProcess = false;
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Image Labeler',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
    );
  }

  void _initializeLabeler() async {
    // uncomment next line if you want to use the default model
    // _imageLabeler = ImageLabeler(options: ImageLabelerOptions());

    // uncomment next lines if you want to use a local model
    // make sure to add tflite model to assets/ml
    // final path = 'assets/ml/lite-model_aiy_vision_classifier_birds_V1_3.tflite';
    // final path = 'assets/ml/object_labeler_flowers.tflite';
    const path = 'assets/ml/object_labeler.tflite';
    final modelPath = await getAssetPath(path);
    final options = LocalLabelerOptions(modelPath: modelPath);
    _imageLabeler = ImageLabeler(options: options);

    // uncomment next lines if you want to use a remote model
    // make sure to add model to firebase
    // final modelName = 'bird-classifier';
    // final response =
    //     await FirebaseImageLabelerModelManager().downloadModel(modelName);
    // print('Downloaded: $response');
    // final options =
    //     FirebaseLabelerOption(confidenceThreshold: 0.5, modelName: modelName);
    // _imageLabeler = ImageLabeler(options: options);

    _canProcess = true;
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    //==============레이블 정보처리 코드================
    final labels = await _imageLabeler.processImage(inputImage);
    //================================================

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = LabelDetectorPainter(labels);
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = '발견: ${labels.length}\n\n';
      for (final label in labels) {
        text += '이름: ${label.label}, '
            '정확도: ${label.confidence.toStringAsFixed(2)}\n\n';
      }
      _text = text;
      _customPaint = null;
      //레이블 정보 처리: 입력 이미지의 메타데이터(inputImage.metadata)에 크기(size)와 회전(rotation) 정보가 있는 경우,
      // LabelDetectorPainter를 사용하여 레이블 정보를 그릴 수 있는 CustomPaint 객체를 생성
      // 그렇지 않은 경우, 각 레이블의 이름(label)과 신뢰도(confidence)를 문자열로 만들어 _text에 저장합니다.
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
      //mounted는 Flutter의 State 클래스에 내장된 변수이다.
      // StatefulWidget의 createState 메서드를 통해 생성된 State 객체가 현재 트리에 마운트되어 있는지를 나타낸다.
      // State 객체가 처음 생성되면 mounted는 false이다.
      // 그러나 buildContext가 State 객체에 연결되고, State 객체가 위젯 트리에 삽입되면 mounted는 true로 설정된다.
      // 만약 State 객체가 위젯 트리에서 제거되면, mounted는 다시 false로 설정된다.
      // mounted 변수는 주로 setState를 안전하게 호출하기 위해 사용된다.
      // State 객체가 위젯 트리에 마운트되어 있지 않은 상태에서 setState를 호출하면, 에러가 발생한다.
      // 따라서 setState를 호출하기 전에 mounted를 체크하여
      // State 객체가 아직 위젯 트리에 있는 경우에만 setState를 호출하는 것이 일반적이다.
    }
  }
}
