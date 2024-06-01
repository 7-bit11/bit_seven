// ignore_for_file: file_names, avoid_print

import 'package:bit_seven/model/personal_dynamicModel.dart';
import 'package:bit_seven/pages/dynamic_detail_message_Controller.dart';
import 'package:bit_seven/utils/netUrl.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

class DynamicDeatilController extends GetxController {
  DynamicDeatilController(this.dyid);

  final String dyid;

  late Rx<DynamicModel> dynamicModel =
      Rx(DynamicModel("", [], "", "", 0, 0, "", "", ""));

  late DynamicDeatilMessageController deatilMessageController =
      DynamicDeatilMessageController(dyid);

  late var isinit = false.obs;

  var isdata = false.obs;

  var isimg = false.obs;

  late String url;

  final TextEditingController textEditingController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    loadDataImg();
    loadDyData();
    Get.put(deatilMessageController);
  }

  void loadDataImg() async {
    ServiceResultData data = await Service.getUserDynamicImgById(dyid);
    if (data.success) {
      url = data.data;
      isimg.value = true;
      if (!isinit.value) {
        await Future.delayed(const Duration(seconds: 2), () {
          isinit.value = true;
        });
      }
    }
  }

  void loadDyData() async {
    ServiceResultData data = await Service.getUserDynamicById(dyid);
    if (data.code == 200) {
      if (data.data != null) {
        try {
          dynamicModel.value = data.data;
        } catch (e) {
          print(e);
        }
        isdata.value = true;
      } else {
        isdata.value = false;
      }
      if (!isinit.value) {
        await Future.delayed(const Duration(seconds: 1), () {
          isinit.value = true;
        });
      }
    } else {
      isdata.value = false;
    }
  }

  void addDynamicMessage(String body) async {
    ServiceResult result = await Service.addDynamicMessage(dyid, body);
    if (result.success) {
      deatilMessageController.loadData();
      EasyLoading.showToast('发送成功',
          duration: const Duration(milliseconds: 1500));
      textEditingController.text = "";
    } else {
      EasyLoading.showError('发送失败,请稍后重试',
          duration: const Duration(milliseconds: 1500));
    }
  }

  /*获取图片主题色 */
  Future<Color> getImageColor() async {
    ImageProvider imageProvider = NetworkImage(
        "${netUrl.bitnetUrl}getImg/21333333312432423423423423423423",
        headers: ServiceTokenHead.headMap);
    Color color = Colors.blue;
    try {
      PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(imageProvider);
      print("paletteGenerator.dominantColor!.color");
      color = paletteGenerator.dominantColor!.color;
      print(paletteGenerator.dominantColor!.color);
    } catch (e) {
      print("eeeeeeeeeeeeeeeee");
      print(e);
    }
    return color;
  }
}
