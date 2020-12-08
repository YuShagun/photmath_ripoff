import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;

import '../models/crop_size.dart';


class CameraProvider {
  static CameraProvider _instance = CameraProvider._internal();

  factory CameraProvider() => _instance;

  CameraDescription _cameraDescription;
  CameraController _controller;

  CameraProvider._internal();

  double get aspectRatio => _controller.value.aspectRatio;

  CameraController get controller => _controller;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    _cameraDescription = cameras.first;
    _controller = CameraController(
      _cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );
    await _controller.initialize();
  }

  Future<String> takePicture({BuildContext context, Size screenSize, CropSize cropSize, Point<double> center}) async {
    final path = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );

    await _controller.takePicture(path);

    imglib.Image image = imglib.decodeImage(File(path).readAsBytesSync());

    double mul = image.width / screenSize.width;

    int x = ((center.x - cropSize.width / 2 ) * mul).toInt();
    int y = ((center.y - cropSize.height / 2) * mul).toInt();
    int w = (cropSize.width * mul).toInt();
    int h = (cropSize.height * mul).toInt();

    print('$mul, $x, $y, $w, $h');

    if(screenSize.width > screenSize.height) {
      int temp = w;
      w = h;
      h = temp;
      temp = x;
      x = y;
      y = temp;
      image = imglib.copyRotate(image, 0);
    }

    imglib.Image cropped = imglib.copyCrop(image, x, y, w, h);

    File(path).writeAsBytesSync(imglib.encodePng(cropped));

    return path;
  }

  void dispose() {
    _controller.dispose();
  }
}