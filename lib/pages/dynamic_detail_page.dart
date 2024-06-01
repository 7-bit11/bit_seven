// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:bit_seven/pages/circle/circlePage.dart';
import 'package:bit_seven/pages/dynamic_detail_Controller.dart';
import 'package:bit_seven/pages/user/message/messagePageWidget.dart';

import 'package:bit_seven/utils/netUrl.dart';
import 'package:bit_seven/utils/overall_situation.dart';
import 'package:bit_seven/widget/image/ImageWidget.dart';
import 'package:bit_seven/widget/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class DynamicDetailPage extends GetView<DynamicDeatilController> {
  DynamicDetailPage(this.dyid, {super.key});
  final String dyid;

  late Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Get.put(DynamicDeatilController(dyid));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Listener(
        onPointerMove: (event) {
          print(event);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Obx(() => controller.isimg.value
                ? ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: MyCachedNetworkImage(
                      controller.url,
                      width: double.infinity,
                    ))
                : Container()),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  floating: false,
                  snap: false,
                  expandedHeight: 120,
                  actions: [
                    GestureDetector(
                        onTapDown: (v) async {
                          await showRightMenu(
                              context, v.globalPosition.dx, v.globalPosition.dy,
                              items: [
                                const MapEntry("收藏", "sc"),
                                const MapEntry("关注", "gz")
                              ]);
                        },
                        child: AbsorbPointer(
                          child: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                                "assets/svg/dots-horizontal.svg"),
                          ),
                        )),
                    const SizedBox(width: 10)
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Obx(() => controller.isimg.value
                        ? Opacity(
                            opacity: .3,
                            child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    MyCachedNetworkImage(controller.url),
                                  ],
                                )),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 150),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: OverallSituation.typea[0], size: 40),
                          )),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => !controller.isinit.value
                                            ? Container(
                                                height: 200,
                                                alignment: Alignment.center,
                                                child: LoadingAnimationWidget
                                                    .staggeredDotsWave(
                                                        color: OverallSituation
                                                            .typea[0],
                                                        size: 40),
                                              )
                                            : !controller.isdata.value
                                                ? Center(
                                                    child: getNoDataWidget(
                                                        size.width / 2))
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        controller.dynamicModel
                                                            .value.tilteName,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            height: 1.5),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              controller
                                                                  .dynamicModel
                                                                  .value
                                                                  .createtime,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                          const SizedBox(
                                                              width: 20),
                                                          TextButton.icon(
                                                              onPressed: () {},
                                                              icon: SvgPicture
                                                                  .asset(
                                                                "assets/svg/thumb-up.svg",
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 20,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              label: Text(
                                                                controller
                                                                    .dynamicModel
                                                                    .value
                                                                    .commentnumber
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              )),
                                                          const SizedBox(
                                                              width: 10),
                                                          TextButton.icon(
                                                              onPressed: () {},
                                                              icon: SvgPicture
                                                                  .asset(
                                                                "assets/svg/chat.svg",
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 20,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              label: Text(
                                                                controller
                                                                    .dynamicModel
                                                                    .value
                                                                    .eyenumber
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ))
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: size.width -
                                                                200,
                                                            height: 40,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: const BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        247,
                                                                        248,
                                                                        250),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                            child: TextField(
                                                                cursorColor:
                                                                    OverallSituation
                                                                        .overallColor,
                                                                controller:
                                                                    controller
                                                                        .textEditingController,
                                                                onSubmitted: (value) =>
                                                                    controller
                                                                        .addDynamicMessage(
                                                                            value),
                                                                decoration:
                                                                    const InputDecoration(
                                                                  prefixText:
                                                                      "     ",
                                                                  hintText:
                                                                      "写评论",
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                )),
                                                          ),
                                                          IconButton(
                                                            icon: SvgPicture.asset(
                                                                "assets/svg/star.svg",
                                                                color: Colors
                                                                    .grey),
                                                            onPressed: () {},
                                                          ),
                                                          IconButton(
                                                            icon: SvgPicture.asset(
                                                                "assets/svg/chat.svg",
                                                                color: Colors
                                                                    .grey),
                                                            onPressed: () {},
                                                          )
                                                        ],
                                                      ),
                                                      const Divider(
                                                        color: Colors.grey,
                                                        height: 50,
                                                      ),
                                                      Text(
                                                          controller
                                                              .dynamicModel
                                                              .value
                                                              .content,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      15)),
                                                      ListView.separated(
                                                        shrinkWrap: true,
                                                        itemCount: controller
                                                            .dynamicModel
                                                            .value
                                                            .imgdata
                                                            .length,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            child:
                                                                MyCachedNetworkImage(
                                                              controller
                                                                  .dynamicModel
                                                                  .value
                                                                  .imgdata[index],
                                                            ),
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return const SizedBox(
                                                              height: 10);
                                                        },
                                                      ),
                                                      const Divider(
                                                        height: 40,
                                                      ),
                                                    ],
                                                  ),
                                      ),
                                      Obx(() => controller.isinit.value
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("评论区",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                const SizedBox(height: 10),
                                                Obx(() => !controller
                                                        .deatilMessageController
                                                        .isinit
                                                        .value
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: LoadingAnimationWidget
                                                            .staggeredDotsWave(
                                                                color:
                                                                    OverallSituation
                                                                        .typea[0],
                                                                size: 40),
                                                      )
                                                    : controller
                                                            .deatilMessageController
                                                            .isdata
                                                            .value
                                                        ? ListView(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            // ignore: invalid_use_of_protected_member
                                                            children: controller
                                                                .deatilMessageController
                                                                .msgList
                                                                // ignore: invalid_use_of_protected_member
                                                                .value
                                                                .map((e) =>
                                                                    UserMessageWidget(
                                                                        e))
                                                                .toList())
                                                        : Center(
                                                            child:
                                                                getNoDataWidget(
                                                                    size.width /
                                                                        2)))
                                              ],
                                            )
                                          : Container()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }, childCount: 1))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
