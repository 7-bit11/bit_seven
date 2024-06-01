// ignore_for_file: file_names, invalid_use_of_protected_member, duplicate_ignore, avoid_print

import 'dart:convert';

import 'package:bit_seven/model/personal_messageModel.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagePageController extends GetxController {
  late RxList<MessageModel> msgList = RxList();
  late var isinit = false.obs;
  var isdata = false.obs;
  @override
  void onInit() {
    super.onInit();
    iscacheData();
    loadData();
  }

  void loadData() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      ServiceResultData data = await Service.getUserMessageList("");
      if (data.code == 200) {
        if (data.data != null) {
          msgList.value = data.data;
          isdata.value = true;
          final shared = await SharedPreferences.getInstance();
          // ignore: invalid_use_of_protected_member
          List<String> list = [];
          for (int i = 0; i < msgList.value.length; i++) {
            list.add(json.encode(msgList.value[i]));
          }
          shared.setStringList("msgList", list);
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
    });
  }

  void iscacheData() async {
    try {
      final shared = await SharedPreferences.getInstance();
      List<String> list = shared.getStringList("msgList")!;
      List<MessageModel> dylist = [];
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = json.decode(list[i]);
        dylist.add(MessageModel.fromJson(map));
      }
      if (dylist.isNotEmpty) {
        msgList.value = dylist;
        isinit.value = true;
        isdata.value = true;
      }
    } catch (e) {
      print("动态没有缓存");
    }
  }
}
