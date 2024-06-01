// ignore_for_file: file_names

import 'package:bit_seven/model/personal_messageModel.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/utils/servicebit.dart';
import 'package:get/get.dart';

class DynamicDeatilMessageController extends GetxController {
  DynamicDeatilMessageController(this.id);
  late RxList<MessageModel> msgList = RxList();
  final String id;
  late var isinit = false.obs;
  var isdata = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    ServiceResultData data = await Service.getDynamicMessageList(id);
    if (data.code == 200) {
      if (data.data != null) {
        msgList.value = data.data;
        isdata.value = true;
      } else {
        isdata.value = false;
      }
      if (!isinit.value) {
        await Future.delayed(const Duration(seconds: 2), () {
          isinit.value = true;
        });
      }
    } else {
      isdata.value = false;
    }
  }
}
