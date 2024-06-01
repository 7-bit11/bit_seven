// ignore_for_file: file_names, invalid_use_of_protected_member, duplicate_ignore, avoid_print

import 'dart:convert';

import 'package:bit_seven/model/personal_collectionModel.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionPageController extends GetxController {
  late RxList<CollectionModel> collectionModelList = RxList(); //数据源

  late var isinit = false.obs; //是否初始化

  late var isgx = false.obs; //是否修改

  var isdata = false.obs;
  @override
  void onInit() {
    super.onInit();
    iscacheData();
    loadData();
  }

  /*初始化数据 */
  void loadData() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      try {
        var data = await Service.getUserCollectionList();
        if (data.code == 200) {
          // ignore: duplicate_ignore
          if (data.data != null) {
            collectionModelList.value = data.data;
            isdata.value = true;
            final shared = await SharedPreferences.getInstance();
            // ignore: invalid_use_of_protected_member
            List<String> list = [];
            for (int i = 0; i < collectionModelList.value.length; i++) {
              list.add(json.encode(collectionModelList.value[i]));
            }
            shared.setStringList("collectionModelList", list);
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
      } catch (e) {
        print("---------------------");
        print(e);
      }
    });
  }

  void iscacheData() async {
    try {
      final shared = await SharedPreferences.getInstance();
      List<String> list = shared.getStringList("collectionModelList")!;
      List<CollectionModel> dylist = [];
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = json.decode(list[i]);
        dylist.add(CollectionModel.fromJson(map));
      }
      if (dylist.isNotEmpty) {
        collectionModelList.value = dylist;
        isinit.value = true;
        isdata.value = true;
      }
    } catch (e) {
      print("动态没有缓存");
    }
  }
}
