import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../home/image_folders.dart';

class RebuildFolders extends StatefulWidget {
  const RebuildFolders({super.key});

  @override
  State<RebuildFolders> createState() => _RebuildFoldersState();
}

class _RebuildFoldersState extends State<RebuildFolders> {
  final ImageFolders _imageFolders = ImageFolders();

  @override
  void initState() {
    super.initState();
    print('이미지 읽기 시작');
    _loadImages();
  }

  Future<void> _loadImages() async {
    List<AssetPathEntity> folderList = await _imageFolders.folderList();
    print('폴더 읽음 ');
    for (AssetPathEntity folder in folderList) {
      List<AssetEntity> imageList = await _imageFolders.imageList(folder);
      print('이미지 ${imageList.length}개');
      // for (AssetEntity image in imageList) {
      //   await _getExifData(image);
      // }
      print('폴더명 : ${folder.name} 파일명 : ${imageList[0].title}');
      await _getExifData(imageList[0]);
      print('Exif 데이터 읽고 나옴');
    }
  }

  Future<void> _getExifData(AssetEntity photo) async {
    print('Exif 데이터 내부로 들어옴 ');

    final file = await photo.originFile;
    if (file == null) {
      print('파일 못 읽음');
    }
    if (file != null) {
      final exif = await file.readAsBytes();
      print('exif 읽음');
      final data = _readExifFromBytes(exif);
      print('exif 데이터 읽음');
      if (!data.containsKey('GPSLatitude') ||
          !data.containsKey('GPSLongitude')) {
        setState(() {
          print('gpsInfo =No GPS  정보가 없음 ');
        });
        return;
      }

      final latitude =
          _convertToDegree(data['GPSLatitude'], data['GPSLatitudeRef']);
      final longitude =
          _convertToDegree(data['GPSLongitude'], data['GPSLongitudeRef']);

      setState(() {
        print('정보 gpsInfo = 위도 : $latitude, 경도 : $longitude');
      });
    }
  }

  Map<String, dynamic> _readExifFromBytes(Uint8List bytes) {
    final Map<String, dynamic> exifData = {};
    final String byteString = bytesToHex(bytes);
    print('byteString = $byteString');
    final RegExp gpsLatRegex = RegExp(
        r'0002000400000001([\dA-Fa-f]{8})0002000400000001([\dA-Fa-f]{8})0002000400000001([\dA-Fa-f]{8})');
    final RegExp gpsLonRegex = RegExp(
        r'0004000400000001([\dA-Fa-f]{8})0004000400000001([\dA-Fa-f]{8})0004000400000001([\dA-Fa-f]{8})');
    final RegExp latRefRegex = RegExp(r'0001000200000002000000([\dA-Fa-f]{2})');
    final RegExp lonRefRegex = RegExp(r'0003000200000002000000([\dA-Fa-f]{2})');

    //===========================================================
    final latMatch = gpsLatRegex.firstMatch(byteString);
    final lonMatch = gpsLonRegex.firstMatch(byteString);
    final latRefMatch = latRefRegex.firstMatch(byteString);
    final lonRefMatch = lonRefRegex.firstMatch(byteString);
    if (latMatch != null && latRefMatch != null) {
      exifData['GPSLatitude'] = [
        int.parse(latMatch.group(1)!, radix: 16),
        int.parse(latMatch.group(2)!, radix: 16),
        int.parse(latMatch.group(3)!, radix: 16),
      ];
      exifData['GPSLatitudeRef'] =
          String.fromCharCode(int.parse(latRefMatch.group(1)!, radix: 16));
    } else {
      print('latMatch가  안됨  $latMatch, latRefMatch 가 안됨  $latRefMatch');
    }

    if (lonMatch != null && lonRefMatch != null) {
      exifData['GPSLongitude'] = [
        int.parse(lonMatch.group(1)!, radix: 16),
        int.parse(lonMatch.group(2)!, radix: 16),
        int.parse(lonMatch.group(3)!, radix: 16),
      ];
      exifData['GPSLongitudeRef'] =
          String.fromCharCode(int.parse(lonRefMatch.group(1)!, radix: 16));
    }

    return exifData;
  }

  String bytesToHex(Uint8List bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  double? _convertToDegree(List<int>? coordinate, String? ref) {
    if (coordinate == null || ref == null || coordinate.length != 3) {
      print('좌표 정보 없음');
      return null;
    }
    final degrees = coordinate[0].toDouble() / 1e7;
    final minutes = coordinate[1].toDouble() / 1e7 / 60;
    final seconds = coordinate[2].toDouble() / 1e7 / 3600;

    double result = degrees + minutes + seconds;
    if (ref == 'S' || ref == 'W') {
      result = -result;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Rebuild Phone Folders'),
      ),
    );
  }
}
