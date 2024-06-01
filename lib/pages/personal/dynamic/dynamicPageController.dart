// ignore_for_file: file_names, invalid_use_of_protected_member, duplicate_ignore, avoid_print

import 'dart:convert';

import 'package:bit_seven/model/personal_dynamicModel.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicPageController extends GetxController
    with StateMixin<List<DynamicModel>> {
  DynamicPageController({this.uaccount});

  late String? uaccount;

  late List<DynamicModel> dynamicModelLists = [];

  //late RxList<DynamicModel> dynamicModelList = RxList();

  var isinit = false.obs;

  var isdata = false.obs;

  var a = false;

  void loadData() async {
    //await Future.delayed(const Duration(seconds: 0), () async {
    ServiceResultData data = await Service.getUserDynamic();
    if (data.code == 200) {
      try {
        // ignore: duplicate_ignore
        if (data.data != null) {
          //dynamicModelList.value = data.data;
          dynamicModelLists = data.data;
          final shared = await SharedPreferences.getInstance();
          // ignore: invalid_use_of_protected_member
          List<String> list = [];
          for (int i = 0; i < dynamicModelLists.length; i++) {
            list.add(json.encode(dynamicModelLists[i]));
          }
          shared.setStringList("dynamicModelList", list);
          isdata.value = true;
          change(dynamicModelLists, status: RxStatus.success());
        } else {
          isdata.value = false;
          change(null, status: RxStatus.empty());
        }
        if (!isinit.value) {
          await Future.delayed(const Duration(seconds: 1), () {
            isinit.value = true;
          });
        }
      } catch (e) {
        print("==========================");
        print(e);
      }
    } else if (data.code == 401) {
      EasyLoading.showToast('网络请求超时..',
          duration: const Duration(milliseconds: 1500));
    } else {
      isdata.value = false;
    }
    // });
  }

  void iscacheData() async {
    try {
      final shared = await SharedPreferences.getInstance();
      //获取缓存数据
      List<String> list = shared.getStringList("dynamicModelList")!;
      List<DynamicModel> dylist = [];
      for (int i = 0; i < list.length; i++) {
        //反序列化
        Map<String, dynamic> map = json.decode(list[i]);
        dylist.add(DynamicModel.fromJson(map));
      }
      //是否有缓存数据
      if (dylist.isNotEmpty) {
        //有缓存数据切换视图状态
        dynamicModelLists = dylist;
        isinit.value = true;
        isdata.value = true;
        change(dynamicModelLists, status: RxStatus.success());
      } else {
        //没有缓存数据页面使用empty状态页面
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      print("动态没有缓存");
    }
  }

  @override
  void onInit() {
    super.onInit();
    change(dynamicModelLists, status: RxStatus.loading());
    iscacheData();
    loadData();
  }
}
