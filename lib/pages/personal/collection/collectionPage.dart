// ignore_for_file: file_names

import 'package:bit_seven/model/personal_collectionModel.dart';
import 'package:bit_seven/pages/personal/collection/video_Page.dart';
import 'package:bit_seven/pages/personal/collection/video_page_controller.dart';
import 'package:bit_seven/utils/netUrl.dart';
import 'package:bit_seven/utils/overall_situation.dart';
import 'package:bit_seven/widget/image/ImageWidget.dart';
import 'package:bit_seven/widget/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'collectionPageController.dart';

class CollectionPage extends GetView<CollectionPageController> {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CollectionPageController());
    final size = MediaQuery.of(context).size;
    return Obx(() => !controller.isinit.value
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: size.width / 2 - 50),
            width: 100,
            height: 30,
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: OverallSituation.typea[0], size: 40),
          )
        : controller.isdata.value
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // ignore: invalid_use_of_protected_member
                itemBuilder: (BuildContext context, int index) {
                  return getitemView(
                      // ignore: invalid_use_of_protected_member
                      controller.collectionModelList.value[index]);
                },
                // ignore: invalid_use_of_protected_member
                itemCount: controller.collectionModelList.value.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 20);
                },
                // children: controller.collectionModelList.value
                //     .map((e) => getitemView(e))
                //     .toList(),
              )
            : getNoDataWidget(size.width / 2));
  }

  Widget getitemView(CollectionModel e) {
    return GestureDetector(
      onTap: () {
        controller.loadData();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 250, 250, 250),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(80, 208, 208, 208),
                blurRadius: 10,
                offset: Offset(0, 5))
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.createTime,
                  style: const TextStyle(fontSize: 15),
                ),
                SvgPicture.asset(
                  "assets/svg/dots-horizontal.svg",
                  color: Colors.grey,
                )
              ],
            ),
            const SizedBox(height: 3),
            GestureDetector(
              onTap: () async {
                await Get.to(const VideoPage());
                //销毁视频页
                VideoController controller = Get.find<VideoController>();
                controller.dispose();
              },
              child: Container(
                width: double.infinity,
                height: 100,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(200, 245, 245, 245),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          MyCachedNetworkImage(
                            e.tilteImgUrl,
                            width: 75,
                            height: 80,
                          ),
                          SvgPicture.asset(
                            "assets/svg/play.svg",
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 180,
                          child: Text(e.tilteName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                              )),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/play-a.svg",
                              width: 15,
                              fit: BoxFit.cover,
                              color: Colors.grey,
                            ),
                            Text(
                              e.videoTime,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
