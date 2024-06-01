// ignore_for_file: invalid_use_of_protected_member, file_names

import 'package:bit_seven/pages/dynamic_detail_Controller.dart';
import 'package:bit_seven/pages/dynamic_detail_page.dart';
import 'package:bit_seven/pages/personal/dynamic/dynamicPageController.dart';
import 'package:bit_seven/widget/noDataWidget.dart';
import 'package:bit_seven/widget/personal/dynamic/dynamicWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicPage extends GetView<DynamicPageController> {
  const DynamicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Get.put(DynamicPageController());
    return controller.obx(
        (state) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.dynamicModelLists.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    await Get.to(
                        DynamicDetailPage(
                            controller.dynamicModelLists[index].id),
                        transition: Transition.rightToLeft);
                    DynamicDeatilController deatilController =
                        Get.find<DynamicDeatilController>();
                    deatilController.dispose();
                  },
                  child: DynamicWidget(controller.dynamicModelLists[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
            ),
        onEmpty: getNoDataWidget(size.width / 2));
    return Obx(() => controller.isdata.value
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.dynamicModelLists.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  await Get.to(
                      DynamicDetailPage(controller.dynamicModelLists[index].id),
                      transition: Transition.rightToLeft);
                  DynamicDeatilController deatilController =
                      Get.find<DynamicDeatilController>();
                  deatilController.dispose();
                },
                child: DynamicWidget(controller.dynamicModelLists[index]),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 20);
            },
          )
        : getNoDataWidget(size.width / 2));
  }
}
