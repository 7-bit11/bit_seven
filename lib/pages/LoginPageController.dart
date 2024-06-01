// ignore_for_file: file_names

import 'package:bit_seven/frame.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RegisterPage.dart';

class LoginPageContorller extends GetxController {
  late TextEditingController userName;

  late TextEditingController password;

  var loginb = false.obs;

  var part = true.obs;

  @override
  void onInit() {
    super.onInit();

    userName = TextEditingController();
    userName.text = "bit";
    password = TextEditingController();
    password.text = "123";
  }

  void isCacheData() async {
    final shared = await SharedPreferences.getInstance();
    try {
      String islogin = shared.getString("token")!;
      if (islogin.isNotEmpty) {
        //请求头初始化
        ServiceTokenHead.initializationHead(islogin);
        Get.offAll(() => FramePage(), transition: Transition.downToUp);
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  /* 登录 */
  void loginUser() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (!loginb.value) {
      EasyLoading.show(status: "登录中");
      loginb.value = true;
      await Future.delayed(const Duration(seconds: 1), () async {
        if (userName.text != "") {
          ServiceResultData loginResult =
              await Service.loginU(userName.text, password.text);
          if (loginResult.success) {
            if (loginResult.code == 408) {
              EasyLoading.showToast('网络请求超时..',
                  duration: const Duration(milliseconds: 1500));
            } else {
              EasyLoading.showToast('登录成功',
                  duration: const Duration(milliseconds: 1500));
              Get.offAll(() => FramePage(), transition: Transition.downToUp);
            }
          } else {
            EasyLoading.showToast('用户名/密码错误',
                duration: const Duration(milliseconds: 1500));
          }
        } else {
          EasyLoading.showToast('用户名/密码不能为空',
              duration: const Duration(milliseconds: 1500));
        }
      });
      loginb.value = false;
    }
  }

  /* 跳转注册页 */
  void goRegisterPage() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    String? result =
        await Get.to(const RegisterPage(), transition: Transition.rightToLeft);
    userName.text = result ?? userName.text;
  }
}
