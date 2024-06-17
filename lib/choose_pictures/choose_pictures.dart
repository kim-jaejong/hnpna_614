import 'package:flutter/material.dart';

// import 'nlp_detector_views/entity_extraction_view.dart';
// import 'nlp_detector_views/language_identifier_view.dart';
// import 'nlp_detector_views/language_translator_view.dart';
// import 'nlp_detector_views/smart_reply_view.dart';
// import 'vision_detector_views/barcode_scanner_view.dart';
// import 'vision_detector_views/digital_ink_recognizer_view.dart';
// import 'vision_detector_views/face_detector_view.dart';
// import 'vision_detector_views/face_mesh_detector_view.dart';
import 'vision_detector_views/label_detector_view.dart';
import 'vision_detector_views/object_detector_view.dart';
// import 'vision_detector_views/pose_detector_view.dart';
import 'vision_detector_views/selfie_segmenter_view.dart';
// import 'vision_detector_views/text_detector_view.dart';

class ChoosePictures extends StatelessWidget {
  const ChoosePictures({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google ML Kit Demo App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text('Vision APIs'),
                    children: [
                      // CustomCard('Barcode Scanning', BarcodeScannerView()),
                      // CustomCard('Face Detection', FaceDetectorView()),
                      // CustomCard('Face Mesh Detection', FaceMeshDetectorView()),
                      CustomCard('Image Labeling', ImageLabelView()),
                      CustomCard('Object Detection', ObjectDetectorView()),
                      // CustomCard('Text Recognition', TextRecognizerView()),
                      // CustomCard('Digital Ink Recognition', DigitalInkView()),
                      // CustomCard('Pose Detection', PoseDetectorView()),
                      CustomCard('Selfie Segmentation', SelfieSegmenterView()),
                    ],
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // ExpansionTile(
                  //   title: const Text('Natural Language APIs'),
                  //   children: [
                  //     CustomCard('Language ID', LanguageIdentifierView()),
                  //     CustomCard(
                  //         'On-device Translation', LanguageTranslatorView()),
                  //     CustomCard('Smart Reply', SmartReplyView()),
                  //     CustomCard('Entity Extraction', EntityExtractionView()),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const CustomCard(this._label, this._viewPage,
      {super.key, this.featureCompleted = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          _label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (!featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('This feature has not been implemented yet')));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => _viewPage));
          }
        },
      ),
    );
  }
}

// ImageLabelView()에서 사용하는 Google ML Kit의 이미지 라벨링 기능은
// 이미지 내의 다양한 객체와 콘텐츠를 인식하고 라벨을 붙일 수 있다.
// 사람과 동물: 사람, 고양이, 개 등의 생물체를 인식하고 라벨을 붙일 수 있다.
// 자연 요소: 산, 강, 바다, 나무 등의 자연 요소를 인식하고 라벨을 붙일 수 있다.
// 건물과 구조물: 집, 아파트, 다리, 탑 등의 건물과 구조물을 인식하고 라벨을 붙일 수 있다.
// 교통 수단: 자동차, 자전거, 비행기, 기차 등의 교통 수단을 인식하고 라벨을 붙일 수 있다.
// 음식: 피자, 사과, 커피 등의 음식을 인식하고 라벨을 붙일 수 있다.
// 이러한 라벨링은 이미지 내의 객체나 콘텐츠를 분류하고, 이미지 검색,
// 이미지 기반의 추천 시스템, 접근성 기능 등에 사용될 수 있다.

// ObjectDetectorView에서 사용하는 Google ML Kit의 객체 감지 기능은
// 이미지 내의 다양한 객체를 감지하고 인식할 수 있다.
// 이는 사람, 동물, 자동차 등과 같은 다양한 객체를 인식할 수 있다.
// 또한, ObjectDetectorView에서는 사용자가 선택한 모델에 따라 다른 종류의 객체를 감지할 수 있다.
// 코드에서 볼 수 있듯이, 사용자는 여러 가지 사전 훈련된 모델 중 하나를 선택할 수 있다.
// 이 모델들은 특정 카테고리의 객체를 감지하는 데 특화되어 있다.
// 예를 들어, 'fruits' 모델은 과일을, 'flowers' 모델은 꽃을, 'birds' 모델은 새를 감지하는 데 사용된다.
// 따라서 ObjectDetectorView에서 감지할 수 있는 객체는 선택한 모델에 따라 다르지만,
// 일반적으로 사람, 동물, 자동차 등의 일반적인 객체를 감지할 수 있으며,
// 특정 모델을 사용하면 과일, 꽃, 새 등의 특정 카테고리의 객체를 감지할 수 있다.

//================================================================================================
// Google ML Kit의 객체 감지 기능은 사전 훈련된 모델을 사용하여 이미지 내의 객체를 감지한다.
// 하지만, 특정 객체를 감지하도록 모델을 추가로 훈련시키는 것은 Google ML Kit의 범위를 벗어난다.
//
// 대신, TensorFlow Lite와 같은 머신러닝 프레임워크를 사용하여 자신만의 모델을 훈련시키고, 이를 앱에 통합할 수 있다.
// 이렇게 훈련된 모델은 TensorFlow Lite 형식으로 변환되어야 하며, 이후에는 Google ML Kit와 유사한 방식으로 사용할 수 있다.
//
// 다음은 이 과정의 개요이다:
// 1. 데이터 수집: 감지하려는 객체의 이미지를 수집합니다. 이 데이터는 모델 훈련에 사용된다.
// 2. 모델 훈련: TensorFlow나 다른 머신러닝 프레임워크를 사용하여 모델을 훈련시킵니다. 이 과정에서는 수집한 데이터를 사용한다.
// 3. 모델 변환: 훈련된 모델을 TensorFlow Lite 형식으로 변환합니다. 이 형식은 모바일 장치에서 사용하기에 적합하다.
// 4. 모델 통합: 변환된 모델을 앱에 통합합니다. 이 과정에서는 TensorFlow Lite Android API나 iOS API를 사용할 수 있다.
//
// 이러한 과정은 머신러닝에 대한 깊은 이해를 필요로 하며, 데이터 수집, 모델 훈련, 모델 최적화 등 복잡한 단계를 포함한다.
// 따라서, 이러한 작업을 수행하려면 머신러닝에 대한 충분한 지식이 필요하다.
