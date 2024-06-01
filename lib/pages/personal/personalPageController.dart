// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:animate_icons/animate_icons.dart';
import 'package:bit_seven/model/personal_userModel.dart';
import 'package:bit_seven/pages/personal/collection/collectionPageController.dart';
import 'package:bit_seven/pages/personal/message/messagePageController.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dynamic/dynamicPageController.dart';
// ignore: depend_on_referenced_packages

class PersonalPageController extends GetxController with StateMixin<User> {
  //动画列表key
  late GlobalKey<SliderDrawerState> mykey = GlobalKey<SliderDrawerState>();
  //动画控制器
  final AnimateIconController animateIconController = AnimateIconController();
  //子页面下标
  late RxInt indexNum = 0.obs;
  final globalKey = GlobalKey<AnimatedListState>();
  //用户对象
  late User user;
  late Rx<User> ux = Rx(user);

  late var isinit = false.obs; //初始化是否成功
  late var initi = false; //是否初始化过
  late var updating = false.obs;
  late var iswhile = true; //是否循环推送消息

  late RxList datalistlength = RxList([1, 2, 3, 4]);

  @override
  void onInit() {
    super.onInit();
    if (!initi) {
      change(null, status: RxStatus.loading());
      initi = true;
      iscacheData();
    }
    loadData();
  }

  void isaaaFun() async {
    while (iswhile) {
      //模拟消息推送间隔5秒
      await Future.delayed(const Duration(seconds: 5), () {
        // ignore: invalid_use_of_protected_member
        if (datalistlength.value.isNotEmpty) {
          // ignore: invalid_use_of_protected_member
          datalistlength.add(
              // ignore: invalid_use_of_protected_member
              datalistlength.value[datalistlength.length - 1] + 1);
        } else {
          // ignore: invalid_use_of_protected_member
          datalistlength.add(1);
        }
        //触发添加动画并添加数据
        globalKey.currentState!.insertItem(datalistlength.length - 1,
            duration: const Duration(milliseconds: 300));
        updating.value = !updating.value;
      });
    }
  }

  void loadData() async {
    dataload(2000);
  }

  void dataload(int milliseconds) async {
    //模拟网络加载太慢
    await Future.delayed(Duration(milliseconds: milliseconds), () async {
      ServiceResultData data = await Service.getUserDetails("");
      if (data.success) {
        try {
          user = data.data;
          //打开数据库-->进行操作
          await openDatabase(User.mydataBase, version: 3,
              onCreate: (db, version) async {
            //创建数据库user表
            //debugPrint();
            print("=====================openDatabase=====================");
            await db.execute(User.sqlCreateusertable);
            //添加数据
            await db.execute(User.getInsterSql(user));
          }, onUpgrade: (db, oldVersion, newVersion) {
            print("数据库升级-->旧版本$oldVersion-->行版本$newVersion");
          });
        } catch (e) {
          print("===================");
          print(e);
          print("===================");
        }
        //获取缓存对象
        final shared = await SharedPreferences.getInstance();
        //将user对象序列化为json存储
        //使用第三方存储插件
        shared.setString("user", json.encode(user));
        ux.value = data.data;
        //改变状态为成功
        change(data.data, status: RxStatus.success());
        isinit.value = true;
      }
    });
  }

  Future<void> onRefresh() async {
    print("触发刷新");
    //模拟网络请求
    await Future.delayed(const Duration(milliseconds: 1000));
    loadData();
    //结束刷新
    try {
      if (indexNum.value == 0) {
        DynamicPageController dyco = Get.find<DynamicPageController>();
        dyco.loadData();
      } else if (indexNum.value == 1) {
        CollectionPageController coco = Get.find<CollectionPageController>();
        coco.loadData();
      } else if (indexNum.value == 2) {
        MessagePageController meco = Get.find<MessagePageController>();
        meco.loadData();
      }
    } catch (e) {
      print("===========刷新异常==========");
      print(e);
    }
  }

  void iscacheData() async {
    try {
      //打开名为user的数据库
      Database myDb = await openDatabase("user.db");
      //查询名为user的表
      List<Map<String, Object?>> userdb = await myDb.query("user");
      // ignore: unused_local_variable
      Map<String, Object?> usermap = userdb.first;
      //将map对象转换为user对象
      user = User.maptoUser(usermap);
      //改变状态为成功
      change(user, status: RxStatus.success());
      //初始化成功
      isinit.value = true;
      //关闭数据库连接
      await myDb.close();
    } catch (e) {
      print("缓存异常");
      print(e);
    }
  }
}
