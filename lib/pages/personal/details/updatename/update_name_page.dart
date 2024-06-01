import 'package:bit_seven/pages/personal/details/detailsPageController.dart';
import 'package:bit_seven/utils/overall_situation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateNamePage extends StatelessWidget {
  const UpdateNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("修改昵称"),
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              onPressed: () {
                DetailsPageController detailsPageController =
                    Get.find<DetailsPageController>();
                detailsPageController.user.userName =
                    textEditingController.text;
                detailsPageController.updateUserDetail();
                detailsPageController.xgname.value =
                    !detailsPageController.xgname.value;
                Get.back();
              },
              child: const Text(
                "保存",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            maxLength: 20,
            buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) =>
                Transform(
                  transform:
                      Matrix4.translationValues(0, -kToolbarHeight + 5, 0),
                  child: Text(
                    "${currentLength.toString()}/20",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
            controller: textEditingController,
            cursorColor: OverallSituation.overallColor,
            decoration: const InputDecoration(
              fillColor: Colors.white, //背景颜色，必须结合filled: true,才有效
              filled: true, //重点，必须设置为true，fillColor才有效
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: OverallSituation.overallColor),
              ),
              hintText: "请输入新昵称",
              hintStyle: TextStyle(color: Colors.grey),
            )),
      ),
    );
  }
}
