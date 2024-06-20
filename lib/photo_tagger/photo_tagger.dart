import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sqflite/sqflite.dart';

class PhotoTagger extends StatefulWidget {
  const PhotoTagger({super.key});

  @override
  State<PhotoTagger> createState() => _PhotoTaggerState();
}

class _PhotoTaggerState extends State<PhotoTagger> {
  final ImagePicker _picker = ImagePicker();
  Database? _database;
  List<Map<String, dynamic>> _photos = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/photos.db';

    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
          CREATE TABLE photos (
            id INTEGER PRIMARY KEY,
            path TEXT,
            tags TEXT
          )
        ''');
    });
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final photos = await _database?.query('photos') ?? [];
    setState(() {
      _photos = photos;
    });
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final imageLabeler =
          ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.7));

      try {
        final labels = await imageLabeler.processImage(inputImage);
        final tags = labels.map((label) => label.label).join(',');

        await _database
            ?.insert('photos', {'path': pickedFile.path, 'tags': tags});
        _loadPhotos();
      } catch (e) {
        // Handle any errors here
      } finally {
        imageLabeler.close();
      }
    }
  }

  Future<void> _searchPhotos(String query) async {
    final photos = await _database
            ?.query('photos', where: 'tags LIKE ?', whereArgs: ['%$query%']) ??
        [];
    setState(() {
      _photos = photos;
    });
  }

  Future<void> _selectPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final imageLabeler =
          ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.7));

      try {
        final labels = await imageLabeler.processImage(inputImage);
        final tags = labels.map((label) => label.label).join(',');
        await _database
            ?.insert('photos', {'path': pickedFile.path, 'tags': tags});
        _loadPhotos();
      } catch (e) {
        // Handle any errors here
      } finally {
        imageLabeler.close();
      }
    }
  }

  Future<void> _processAllPhotos() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
        start: 0, end: 1000000); // 모든 사진을 가져옵니다.

    for (final asset in recentAssets) {
      final file = await asset.originFile;
      final inputImage = InputImage.fromFilePath(file!.path);
      final imageLabeler =
          ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.7));

      try {
        final labels = await imageLabeler.processImage(inputImage);
        final tags = labels.map((label) => label.label).join(',');

        await _database?.insert('photos', {'path': file.path, 'tags': tags});
      } catch (e) {
        // Handle any errors here
      } finally {
        imageLabeler.close();
      }
    }

    _loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Photo Tagger'), actions: [
          IconButton(icon: const Icon(Icons.camera), onPressed: _takePhoto),
          IconButton(icon: const Icon(Icons.photo), onPressed: _selectPhoto),
          IconButton(
              icon: const Icon(Icons.select_all), onPressed: _processAllPhotos),
          // 갤러리
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final query = await _showSearchDialog();
                if (query != null && query.isNotEmpty) {
                  _searchPhotos(query);
                }
              })
        ]),
        body: ListView.builder(
            itemCount: _photos.length,
            itemBuilder: (context, index) {
              final photo = _photos[index];
              return ListTile(
                  leading: Image.file(File(photo['path'])),
                  title: Text(photo['tags']));
            }));
  }

  Future<String?> _showSearchDialog() async {
    return showDialog<String>(
        context: context,
        builder: (context) {
          String query = '';
          return AlertDialog(
              title: const Text('Search Photos'),
              content: TextField(
                  onChanged: (value) {
                    query = value;
                  },
                  decoration:
                      const InputDecoration(hintText: 'Enter tags to search')),
              actions: [
                TextButton(
                    child: const Text('Search'),
                    onPressed: () {
                      Navigator.of(context).pop(query);
                    })
              ]);
        });
  }
}

//Flutter를 사용하여 사진을 촬영하고, 사진의 내용을 분석하여 태그를 저장하고 검색하는 기능을 구현할 수 있습니다.
// 이를 위해 다음과 같은 라이브러리와 서비스를 사용할 수 있습니다:
//
// image_picker: 사진 촬영 및 선택을 위한 플러그인
// firebase_ml_vision 또는 google_ml_kit: 사진의 내용을 분석하기 위한 머신러닝 라이브러리
// sqflite: 태그와 사진 경로를 로컬 데이터베이스에 저장하기 위한 SQLite 플러그인
// 이 코드는 기본적인 예제이므로 실제 애플리케이션에서는 에러 처리, 성능 최적화 등을 추가로 고려해야 합니다.

//이 코드는 Flutter를 사용하여 사진을 촬영하고,
// Google ML Kit의 ImageLabeler를 사용하여 사진의 라벨을 추출하고,
// 이 라벨을 SQLite 데이터베이스에 저장하는 기능을 구현하고 있습니다.
// 또한, 사용자가 태그를 입력하여 사진을 검색하는 기능도 구현하고 있습니다.
// 이미지를 촬영하고 라벨을 추출하는 부분은 _takePhoto 메서드에서 처리하고 있습니다.
// 이 메서드는 ImagePicker를 사용하여 사진을 촬영하고, ImageLabeler를 사용하여 사진에서 라벨을 추출합니다.
// 추출된 라벨은 데이터베이스에 저장되며, 이후에 라벨을 기반으로 사진을 검색할 수 있습니다.
// 사진을 검색하는 기능은 _searchPhotos 메서드에서 처리하고 있습니다.
// 이 메서드는 사용자가 입력한 쿼리를 기반으로 데이터베이스에서 사진을 검색합니다.
// 검색 결과는 _photos 리스트에 저장되며, 이 리스트는 build 메서드에서 ListView.builder를 사용하여 화면에 표시됩니다.

//갤러리에서 이미지를 선택하는 기능을 추가해야 합니다.
// 이를 위해 _takePhoto 메서드와 유사한 새로운 메서드를 만들어야 합니다.
// 이 새로운 메서드를 _selectPhoto라고 부르겠습니다.
// 이 메서드는 ImagePicker를 사용하여 갤러리에서 이미지를 선택하고, 선택한 이미지에 대해 라벨링을 수행한 후,
// 라벨을 데이터베이스에 저장합니다.
// 또한, AppBar에 새로운 IconButton을 추가하여 사용자가 갤러리에서 이미지를 선택할 수 있도록 해야 합니다.

//_processAllPhotos() 는 photo_manager 패키지를 사용하여 핸드폰 내의 모든 사진에 접근합니다.
// 각 사진에 대해 ImageLabeler를 사용하여 라벨링을 수행하고, 라벨을 데이터베이스에 저장합니다.
// 이후에는 라벨을 기반으로 사진을 검색할 수 있습니다.
// 이 메서드를 호출하려면, 예를 들어 initState 메서드에서 _processAllPhotos를 호출할 수 있습니다.
// 그러나 이 메서드는 많은 시간이 소요될 수 있으므로, 비동기 처리를 고려해야 합니다.
// 또한, 이 코드는 모든 사진을 처리하므로 많은 양의 메모리를 사용할 수 있습니다.
// 따라서 실제 애플리케이션에서는 메모리 사용량을 최적화하고,
// 사용자에게 진행 상황을 표시하는 등의 추가적인 고려사항이 있을 수 있습니다.

//DateTime endDate = DateTime.now();
// DateTime startDate = endDate.subtract(Duration(days: 30));
//
// final recentAssets = await recentAlbum.getAssetListRange(start: 0, end: 1000000);
//
// for (final asset in recentAssets) {
//   if (asset.creationDateTime!.isAfter(startDate) &&
//       asset.creationDateTime!.isBefore(endDate)) {
//     final file = await asset.originFile;
//     final inputImage = InputImage.fromFilePath(file!.path);
//     final imageLabeler =
//         ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.7));
//
//     try {
//       final labels = await imageLabeler.processImage(inputImage);
//       final tags = labels.map((label) => label.label).join(',');
//
//       await _database?.insert('photos', {'path': file.path, 'tags': tags});
//     } catch (e) {
//       // Handle any errors here
//     } finally {
//       imageLabeler.close();
//     }
//   }
// }

//모든 사진을 가져온 후 Dart 코드에서 필터링을 수행해야 합니다.
// 이 코드는 getAssetListRange 메서드를 사용하여 모든 사진을 가져온 후, 각 사진의 creationDateTime이 최근 한 달 이내인지 확인합니다.
// 만약 그렇다면, 해당 사진에 대해 라벨링을 수행하고 라벨을 데이터베이스에 저장합니다.
