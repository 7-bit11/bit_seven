import 'package:bit_seven/utils/netUrl.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  VideoController(this.videourl);
  final String videourl;

  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;

  late var isinitData = false.obs;

  late var isinit1 = false.obs;

  late var gk = 1.0.obs;
  @override
  void onInit() {
    super.onInit();
    initData();
    initVideo();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  void initData() async {
    videoPlayerController = VideoPlayerController.network(
        "${netUrl.bitnetUrl}getVideo/1",
        httpHeaders: ServiceTokenHead.headMap!);
    // videoPlayerController = VideoPlayerController.network(
    //     "${netUrl.bitnetUrl}getVideo/$videourl",
    //     httpHeaders: ServiceTokenHead.headMap!);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      //autoPlay: true,
      //aspectRatio: 9/16,
      showControls: true,
      autoInitialize: true,
      allowMuting: true,
      // placeholder: LoadingAnimationWidget.staggeredDotsWave(
      //     color: OverallSituation.typea[0], size: 40),
      materialProgressColors: ChewieProgressColors(
          handleColor: Colors.blue,
          backgroundColor: Colors.white,
          playedColor: Colors.blue),
    );
  }

  void initVideo() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (videoPlayerController.value.isInitialized) {
        isinitData.value = false;
        isinit1.value = true;
        gk.value = videoPlayerController.value.aspectRatio;
        chewieController.play();
        break;
      }
    }
  }
}
