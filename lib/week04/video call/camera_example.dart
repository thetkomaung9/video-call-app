import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MyApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);
  @override
  State<CameraApp> createState() => _CameraAppState();
  
}
class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  @override
  void initState() {
    super.initState();
    
}