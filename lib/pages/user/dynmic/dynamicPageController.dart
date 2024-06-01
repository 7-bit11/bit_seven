// ignore_for_file: file_names, avoid_print

import 'package:bit_seven/model/personal_dynamicModel.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:get/get.dart';

class UserDynamicPageController extends GetxController {
  UserDynamicPageController({this.uaccount});

  late String? uaccount;

  late RxList<DynamicModel> dynamicModelList = RxList();

  var isinit = false.obs;

  var isdata = false.obs;

  void loadData() async {
    ServiceResultData data = await Service.getUserDynamicx(uaccount);
    if (data.code == 200) {
      try {
        if (data.data != null) {
          dynamicModelList.value = data.data;
          isdata.value = true;
        } else {
          isdata.value = false;
        }
        if (!isinit.value) {
          await Future.delayed(const Duration(seconds: 2), () {
            isinit.value = true;
          });
        }
      } catch (e) {
        print("==========================");
        print(e);
      }
    } else {
      isdata.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    print("UserDynamicPageController销毁");
  }
}
