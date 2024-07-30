import 'package:flutter/material.dart';
import 'package:talya_flutter/Modules/Page/qr-scanner-page.dart';
import 'package:video_player/video_player.dart';
import 'package:talya_flutter/Global/constants.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/dashboard.mp4')
      ..initialize().then((_) {
        setState(() {
          controller.play();
          controller.setLooping(false);
          controller.addListener(checkVideo);
        });
      });
  }

  void checkVideo() {
    if (controller.value.position >= controller.value.duration) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => QRScannerPage()),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body:  Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            :  CircularProgressIndicator(),
      ),
    );
  }
}