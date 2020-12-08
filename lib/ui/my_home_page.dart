import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'about.dart';
import 'display_solution.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;

import 'app_drawer.dart';
import '../models/crop_size.dart';
import 'crop/crop.dart';
import 'history_screen.dart';


class MyHomePage extends StatefulWidget {
  final CameraDescription camera;
  final String title;

  MyHomePage({
    Key key,
    this.title,
    @required this.camera,
  }) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  Point<double> _cropRectCenter;
  final CropSize _size = CropSize(width: 250, height: 110);


  Future<String> takePicture(BuildContext context, Size screenSize) async {
    await _initializeControllerFuture;

    final path = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    final croppedPath = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    await _controller.takePicture(path);

    imglib.Image image = imglib.decodeImage(File(path).readAsBytesSync());

    double mul = image.width / screenSize.width;
    
    int x = ((_cropRectCenter.x - _size.width / 2 ) * mul).toInt();
    int y = ((_cropRectCenter.y - _size.height / 2) * mul).toInt();
    int w = (_size.width * mul).toInt();
    int h = (_size.height * mul).toInt();

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

    File(croppedPath).writeAsBytesSync(imglib.encodePng(cropped));

    return croppedPath;
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
        widget.camera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _cropRectCenter = Point<double>(
        screenSize.width / 2,
        ((screenSize.width + 40) / 2) / 16 * 9 + 80,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryScreen(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                title: Text('About'),
                children: [
                  AboutDialogContent(),
                ],
              )
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return  Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
                Crop(
                  screenSize: screenSize,
                  center: _cropRectCenter,
                  size: _size,
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Container(
            child: Icon(Icons.stop_circle),
          ),
          onPressed: () async {
            String path = await takePicture(context, screenSize);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplaySolution.fromImage(imgPath: path),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
