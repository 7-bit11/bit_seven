import 'dart:io';

import 'package:bit_seven/model/personal_messageModel.dart';
import 'package:bit_seven/pages/circle/circlePage.dart';
import 'package:bit_seven/pages/home/HomePage.dart';
import 'package:bit_seven/pages/nearby/nearbyPage.dart';
import 'package:bit_seven/pages/personal/PersonalPage.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'pages/personal/dynamic/dynamicPageController.dart';

class FrameController extends GetxController {
  late final List<MessageModel> _msgList = [
    MessageModel("", "", "assets/images/wallhaven-zyz25o.jpg", "日落",
        "为什么太阳会落下呢", "20小时前"),
    MessageModel("", "", "assets/images/wallhaven-rrgxdq.jpg", "海南",
        "快来看看海南的夏天", "20小时前"),
    MessageModel(
        "", "", "assets/images/wallhaven-2yzx89.jpg", "草原", "牛羊草原遍地走", "20小时前"),
    MessageModel("", "", "assets/images/wallhaven-2yzl89.jpg", "跑车",
        "看我的这个跑车怎么样", "20小时前"),
    MessageModel("", "", "assets/images/wallhaven-85ew6j.jpg", "猫猫虫",
        "最喜欢在太阳下睡觉", "20小时前")
  ];
  late List<Widget> itemPage = [
    const HomePage(),
    const CirclePage(),
    NearbyPage(_msgList),
    PersonalPage()
  ];

  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController bodycontroller = TextEditingController();
  final BottomBarWithSheetController bcontroller =
      BottomBarWithSheetController(initialIndex: 3);
  var indexPage = 3.obs;

  late RxList<File> fileimgs = RxList();

  late var isdata = false.obs;

  late var isinit = false.obs;

  late bool issend = false;
  void onsend() async {
    if (!issend) {
      issend = true;
      // ignore: invalid_use_of_protected_member
      if (titlecontroller.text.isNotEmpty) {
        // ignore: invalid_use_of_protected_member
        if (fileimgs.value.isNotEmpty) {
          EasyLoading.show(status: "发表中...");
          ServiceResultData data = await Service.addDynamicDetail(
              // ignore: invalid_use_of_protected_member
              fileimgs.value,
              titlecontroller.text,
              bodycontroller.text);
          if (data.success) {
            EasyLoading.showToast('发表成功',
                duration: const Duration(milliseconds: 1500));
            bcontroller.closeSheet();
            titlecontroller.text = "";
            bodycontroller.text = "";
            isdata.value = false;
            isinit.value = false;
            fileimgs.value = [];
            DynamicPageController dyco = Get.find<DynamicPageController>();
            dyco.loadData();
          } else {
            EasyLoading.showToast('未知错误',
                duration: const Duration(milliseconds: 1500));
          }
        } else {
          EasyLoading.showToast('图片不能为空',
              duration: const Duration(milliseconds: 1500));
        }
      } else {
        EasyLoading.showToast('标题不能为空',
            duration: const Duration(milliseconds: 1500));
      }
    }
    issend = false;
  }
}
