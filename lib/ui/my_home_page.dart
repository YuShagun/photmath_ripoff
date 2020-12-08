import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:photomath_ripoff/camera/camera_provider.dart';
import 'about.dart';
import 'display_solution.dart';

import 'app_drawer.dart';
import '../models/crop_size.dart';
import 'crop/crop.dart';
import 'history_screen.dart';


class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  Future<void> _initializeControllerFuture;

  Point<double> _cropRectCenter;
  final CropSize _size = CropSize(width: 250, height: 110);

  Future<void> takePictureAndRedirect(Size screenSize) async {
    String path = await CameraProvider().takePicture(
      context: context,
      screenSize: screenSize,
      cropSize: _size,
      center: _cropRectCenter,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplaySolution.fromImage(imgPath: path),
      ),
    );
  }

  void showInfo() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('About'),
        children: [
          AboutDialogContent(),
        ],
      ),
    );
  }

    @override
    void initState() {
      super.initState();
      _initializeControllerFuture = CameraProvider().initializeCamera();
    }

    @override
    void dispose() {
      // Dispose of the controller when the widget is disposed.
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
            onPressed: showInfo,
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
                  aspectRatio: CameraProvider().aspectRatio,
                  child: CameraPreview(CameraProvider().controller),
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
          onPressed: () => takePictureAndRedirect(screenSize),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
