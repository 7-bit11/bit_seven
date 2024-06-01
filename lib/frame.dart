// ignore_for_file: invalid_use_of_protected_member, duplicate_ignore

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:bit_seven/frame_conrtoller.dart';
import 'package:bit_seven/utils/android_call.dart';
import 'package:bit_seven/utils/overall_situation.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FramePage extends GetView<FrameController> {
  FramePage({super.key});
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    Get.put(FrameController());

    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          await AndroidCall.backDesktop();
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Obx(() => PageTransitionSwitcher(
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                child: controller.itemPage[controller.indexPage.value])),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: BottomBarWithSheet(
                onSelectItem: (v) {
                  controller.indexPage.value = v;
                },
                controller: controller.bcontroller,
                autoClose: true,
                sheetChild: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(245, 245, 245, 245),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40))),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 60),
                            const Text("写动态", style: TextStyle(fontSize: 20)),
                            SizedBox(
                              width: 60,
                              height: 30,
                              child: GradientButton(
                                  onPressed: () {
                                    controller.onsend();
                                  },
                                  colors: OverallSituation.typea,
                                  child: const Text("发表")),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 10),
                          constraints: const BoxConstraints(minHeight: 30),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: TextField(
                            controller: controller.titlecontroller,
                            maxLines: 3,
                            minLines: 1,
                            cursorColor: OverallSituation.overallColor,
                            decoration: const InputDecoration(
                              hintText: "标题",
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(0, 158, 158, 158)),
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 10),
                          constraints: const BoxConstraints(minHeight: 100),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: TextField(
                            controller: controller.bodycontroller,
                            maxLines: 20,
                            minLines: 1,
                            cursorColor: OverallSituation.overallColor,
                            decoration: const InputDecoration(
                              hintText: "有趣的内容",
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(0, 158, 158, 158)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            // ignore: invalid_use_of_protected_member
                            child: Obx(() => !controller.isinit.value
                                ? StaggeredGrid.count(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    children: [
                                        GestureDetector(
                                          onTap: () {
                                            myshowModalBottomSheet(context);
                                          },
                                          child: Container(
                                            width: size.width / 3 - 15,
                                            height: size.width / 3 - 35,
                                            color: const Color.fromARGB(
                                                245, 245, 245, 245),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/picture.svg",
                                                  color: Colors.grey,
                                                  width: 20,
                                                ),
                                                const Text("照片/拍摄",
                                                    style: TextStyle(
                                                        color: Colors.grey))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ])
                                : controller.isdata.value
                                    ? SizedBox(
                                        width: double.infinity,
                                        height: 330,
                                        child: MasonryGridView.count(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          itemCount:
                                              // ignore: invalid_use_of_protected_member
                                              controller.fileimgs.value.length +
                                                  1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Widget mywidget = Container(
                                              color: Colors.red,
                                              width: 100,
                                              height: 100,
                                            );
                                            if (index == 0) {
                                              mywidget = GestureDetector(
                                                onTap: () {
                                                  myshowModalBottomSheet(
                                                      context);
                                                },
                                                child: Container(
                                                  width: size.width / 3 - 15,
                                                  height: size.width / 3 - 35,
                                                  color: const Color.fromARGB(
                                                      245, 245, 245, 245),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/svg/picture.svg",
                                                        color: Colors.grey,
                                                        width: 20,
                                                      ),
                                                      const Text("照片/拍摄",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              mywidget = Image.file(
                                                controller
                                                    // ignore: invalid_use_of_protected_member
                                                    .fileimgs
                                                    .value[index - 1],
                                                width: size.width / 3 - 15,
                                                height: size.width / 3 - 35,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                            return mywidget;
                                          },
                                        ),
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 330,
                                        child: MasonryGridView.count(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          itemCount:
                                              // ignore: invalid_use_of_protected_member
                                              controller.fileimgs.value.length +
                                                  1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Widget mywidget = Container(
                                              color: Colors.red,
                                              width: 100,
                                              height: 100,
                                            );
                                            if (index == 0) {
                                              mywidget = GestureDetector(
                                                onTap: () {
                                                  myshowModalBottomSheet(
                                                      context);
                                                },
                                                child: Container(
                                                  width: size.width / 3 - 15,
                                                  height: size.width / 3 - 35,
                                                  color: const Color.fromARGB(
                                                      245, 245, 245, 245),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/svg/picture.svg",
                                                        color: Colors.grey,
                                                        width: 20,
                                                      ),
                                                      const Text("照片/拍摄",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              mywidget = Image.file(
                                                controller
                                                    // ignore: invalid_use_of_protected_member
                                                    .fileimgs
                                                    .value[index - 1],
                                                width: size.width / 3 - 15,
                                                height: size.width / 3 - 35,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                            return mywidget;
                                          },
                                        ),
                                      )))
                      ],
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 700),
                curve: Curves.fastOutSlowIn,
                bottomBarTheme: BottomBarTheme(
                  contentPadding:
                      const EdgeInsets.only(top: 10, left: 5, right: 5),
                  height: 65,
                  heightClosed: 65,
                  heightOpened: size.height - 120,
                  mainButtonPosition: MainButtonPosition.middle,
                  selectedItemIconColor: OverallSituation.overallColor,
                  itemIconColor: Colors.grey[500],
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: .9)],
                  ),
                ),
                mainActionButtonTheme: MainActionButtonTheme(
                  size: 35,
                  color: OverallSituation.overallColor,
                  splash: Colors.blue[800],
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                items: const [
                  BottomBarWithSheetItem(icon: Icons.home_rounded),
                  BottomBarWithSheetItem(icon: Icons.bar_chart_sharp),
                  BottomBarWithSheetItem(icon: Icons.favorite),
                  BottomBarWithSheetItem(icon: Icons.person),
                ],
              ),
            ),
          ),
        ));
  }

  Future myshowModalBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      elevation: 120,
      context: context,
      barrierColor: Colors.grey.withOpacity(0.2),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "提示",
                style:
                    TextStyle(color: OverallSituation.typea[0], fontSize: 27),
              ),
              const Text(
                "选择发表动态的照片",
                style: TextStyle(fontSize: 22),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: GradientButton(
                          borderRadius: BorderRadius.circular(13),
                          colors: OverallSituation.typeb,
                          onPressed: () {
                            inPhotoAlbumSelection();
                            Navigator.of(context).pop();
                          },
                          child: const Text("从相册选择",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey)))),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: GradientButton(
                          borderRadius: BorderRadius.circular(13),
                          colors: OverallSituation.typeb,
                          onPressed: () {
                            takePicture();
                            Navigator.of(context).pop();
                          },
                          child: const Text("拍一张",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey)))),
                ],
              ),
            ],
          ),
        );
      },
      constraints:
          BoxConstraints(maxWidth: size.width - 20, minWidth: size.width - 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    );
  }

  /*从相册选择图片上传 */
  void inPhotoAlbumSelection() async {
    FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);
    if (filePickerResult != null) {
      // PlatformFile? file = filePickerResult?.files.first;
      // if (file?.path != null) {
      //   File file1 = File(file!.path!);
      //   var data =
      //       await Get.to(CutImagePage(file1), transition: Transition.downToUp);
      // }
      List<File> files =
          filePickerResult.paths.map((path) => File(path!)).toList();
      // ignore: invalid_use_of_protected_member
      if (files.length + controller.fileimgs.value.length >= 9) {
        EasyLoading.showToast('最多选择8张',
            duration: const Duration(milliseconds: 1500));
        return;
      }
      //添加到列表中
      // ignore: invalid_use_of_protected_member
      controller.fileimgs.value.addAll(files);

      controller.isinit.value = true;
      controller.isdata.value = !controller.isdata.value;
    }
  }

  /* 拍一张图片进行上传 */
  void takePicture() async {
    var filex = await picker.pickImage(source: ImageSource.camera);
    File file123 = File.fromUri(Uri.parse(filex!.path));
    // var data =
    //     await Get.to(CutImagePage(file123), transition: Transition.downToUp);
    // File file = File.fromRawPath(data);
    // File.
    // ignore: invalid_use_of_protected_member
    if (controller.fileimgs.value.length >= 8) {
      EasyLoading.showToast('最多拍摄8张',
          duration: const Duration(milliseconds: 1500));
      return;
    }
    // ignore: invalid_use_of_protected_member
    controller.fileimgs.value.add(file123);
    controller.isinit.value = true;
    controller.isdata.value = !controller.isdata.value;
    //uploadImage(data);
  }
}
