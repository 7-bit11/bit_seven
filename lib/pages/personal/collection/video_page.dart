import 'dart:ui';

import 'package:bit_seven/pages/personal/collection/video_page_controller.dart';
import 'package:bit_seven/utils/overall_situation.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VideoPage extends GetView<VideoController> {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Get.put(VideoController("videotest1"));
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0, backgroundColor: Colors.black, toolbarHeight: 10),
        body: ListView(
          children: [
            Obx(() => SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: !controller.isinitData.value
                      ? controller.gk.value == 1.0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width / 2 - 50),
                              width: 100,
                              height: 30,
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: OverallSituation.typea[0], size: 40),
                            )
                          : ClipRect(
                              child: SizedBox(
                                height: 350,
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 300,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Chewie(
                                          controller:
                                              controller.chewieController,
                                        ),
                                      ),
                                    ),
                                    BackdropFilter(
                                      /// 过滤器
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),

                                      /// 必须设置一个空容器
                                      child: Container(
                                        height: 400,
                                      ),
                                    ),
                                    AspectRatio(
                                      aspectRatio: controller
                                          .videoPlayerController
                                          .value
                                          .aspectRatio,
                                      child: Chewie(
                                        controller: controller.chewieController,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                      : LoadingAnimationWidget.staggeredDotsWave(
                          color: OverallSituation.typea[0], size: 40),
                )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            "assets/images/my.jpg",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "7_bit",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "14415粉丝",
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                    ]),
                    Container(
                        alignment: Alignment.center,
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular((13.0)),
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.3, 1.0],
                                colors: OverallSituation.typea)),
                        child: const Text("关注",
                            style: TextStyle(color: Colors.white)))
                  ],
                ),
                Row(
                  children: const [
                    Icon(Icons.video_call, color: Colors.grey),
                    Text("99万", style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text("校园*日常", style: TextStyle(color: Colors.grey))
                  ],
                ),
                const Text(
                  "高中一年级的白石纯太， 是一个零存在感的“路人”男生。同班的“女主角级”美少女·久保同学居然是唯一能找到他的人",
                  style: TextStyle(color: Colors.grey),
                )
              ]),
            ),
            // SizedBox(height: 50),
            // Container(
            //   height: 100,
            //   color: Colors.red,
            // ),
            // Container(
            //   height: 100,
            //   color: Colors.blue,
            // ),
            // Container(
            //   height: 100,
            //   color: Colors.green,
            // ),
            // Container(
            //   height: 100,
            //   color: Colors.yellow,
            // ),
            // Container(
            //   height: 100,
            //   color: Colors.orange,
            // ),
          ],
        ));
  }
}
