// ignore_for_file: file_names, invalid_use_of_protected_member, duplicate_ignore

import 'package:bit_seven/pages/dynamic_detail_Controller.dart';
import 'package:bit_seven/pages/dynamic_detail_page.dart';
import 'package:bit_seven/pages/user/dynmic/dynamicPageController.dart';
import 'package:bit_seven/utils/overall_situation.dart';
import 'package:bit_seven/widget/noDataWidget.dart';
import 'package:bit_seven/widget/personal/dynamic/dynamicWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserDynamicPage extends GetView<UserDynamicPageController> {
  const UserDynamicPage(this.account, {super.key});
  final String account;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Get.put(UserDynamicPageController(uaccount: account));
    return Obx(() => !controller.isinit.value
        ? LoadingAnimationWidget.staggeredDotsWave(
            color: OverallSituation.typea[0], size: 40)
        : controller.isdata.value
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // ignore: invalid_use_of_protected_member
                itemCount: controller.dynamicModelList.value.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      await Get.to(
                          DynamicDetailPage(
                              controller.dynamicModelList.value[index].id),
                          transition: Transition.rightToLeft);
                      DynamicDeatilController deatilController =
                          Get.find<DynamicDeatilController>();
                      deatilController.dispose();
                    },
                    child: DynamicWidget(
                        // ignore: invalid_use_of_protected_member
                        controller.dynamicModelList.value[index]),
                  );
                })
            : getNoDataWidget(size.width / 2));
  }
}
