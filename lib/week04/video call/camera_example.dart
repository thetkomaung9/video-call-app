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

    initializeCamera();
}
initializeCamera() async {
  try {
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    await controller.initialize();

    setState(() {});
  } catch (e){
    if (e is CameraException){
      switch (e.code){
        case 'CameraAccessDenied':
        break;
        default:
        print('Handle other errors');
        break;

      }
    }
  }
}
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
@override
Widget build(BuildContext context) {

  if(!controller.value.isInitialized){
    return Container();
  }
  return MaterialApp(
    home: Cam
  )
}