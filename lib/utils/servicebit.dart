// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bit_seven/model/personal_collectionModel.dart';
import 'package:bit_seven/model/personal_dynamicModel.dart';
import 'package:bit_seven/model/personal_messageModel.dart';
import 'package:bit_seven/model/personal_userModel.dart';
import 'package:bit_seven/model/user_dto.dart';
import 'package:bit_seven/pages/LoginPage.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bit_seven/utils/netUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  /* 登录 */
  static Future<ServiceResultData> loginU(String name, String password) async {
    ServiceResultData serviceResult = ServiceResultData();
    http.Response url;
    try {
      url = await http.post(Uri.parse("${netUrl.bitnetUrl}login.do"), body: {
        'userName': name,
        'password': password
      }).timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("请求超时", 408);
      });
      if (url.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(url.body);
        serviceResult = ServiceResultData.fromJson(data);
        if (serviceResult.success) {
          serviceResult.success = true;
          //token存储全局
          final shared = await SharedPreferences.getInstance();
          shared.setString("token", serviceResult.data);

          //请求头初始化
          ServiceTokenHead.initializationHead(serviceResult.data);
        }
      } else if (url.statusCode == 408) {
        serviceResult.code = url.statusCode;
        serviceResult.success = true;
        serviceResult.msg = url.body;
      }
    } catch (e) {
      serviceResult.code = 408;
      serviceResult.success = true;
      serviceResult.msg = e.toString();
    }
    return serviceResult;
  }

  /*获取用户详细信息 */
  static Future<ServiceResultData> getUserDetails(String account) async {
    ServiceResultData serviceResult = ServiceResultData();
    try {
      var url = await http.get(
          Uri.parse(
              "${netUrl.bitnetUrl}user/getUserDetails.do?account=$account"),
          headers: ServiceTokenHead.headMap);
      if (url.statusCode == 401) {
        istokentimeout(statefunctionServiceResultData(serviceResult));
      }
      if (url.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(url.body);
        serviceResult = ServiceResultData.fromJson(data);
        if (serviceResult.success) {
          serviceResult.data = User.fromJson(serviceResult.data);
        }
      }
    } catch (e) {
      print(e);
    }
    return serviceResult;
  }

  static ServiceResultData statefunctionServiceResultData(
      ServiceResultData serviceResult) {
    serviceResult.data = "";
    serviceResult.code = 401;
    serviceResult.success = false;
    serviceResult.msg = "用户信息过期，请重新登录";
    return serviceResult;
  }

  static ServiceResult statefunctionServiceResult(ServiceResult serviceResult) {
    serviceResult.code = 401;
    serviceResult.success = false;
    serviceResult.msg = "用户信息过期，请重新登录";
    return serviceResult;
  }

  static void istokentimeout(ServiceResult serviceResult) async {
    if (serviceResult.code == 401) {
      await EasyLoading.showToast(serviceResult.msg,
          duration: const Duration(milliseconds: 2000));
      Get.offAll(LoginPage(), transition: Transition.upToDown);
    }
  }

  /*日期转换 */
  static String getCurrentTime(DateTime dateTime) {
    String currentTime = formatDate(
        dateTime, [yyyy, '-', mm, '-', dd, '-', ' ', HH, ':', mm, ':', ss]);
    return currentTime;
  }

  /*更新用户详细信息 */
  static Future<ServiceResult> updateUserDetails(User user) async {
    UserDto userDto = UserDto(
        user.userName,
        user.userImgUrl,
        user.introduce,
        getCurrentTime(user.birthday),
        user.province,
        user.city,
        user.town,
        user.occupation,
        user.userSex);
    ServiceResult serviceResult = ServiceResult();
    Map s = userDto.toJson();
    try {
      var url = await http.post(
        Uri.parse("${netUrl.bitnetUrl}user/updateUserDetails.do"),
        headers: ServiceTokenHead.headMap,
        body: s,
      );
      if (url.statusCode == 401) {
        istokentimeout(statefunctionServiceResult(serviceResult));
      }
      if (url.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(url.body);
        serviceResult = ServiceResult.fromJson(data);
        if (serviceResult.success) {}
      }
    } catch (e) {
      print(e);
    }
    return serviceResult;
  }

  /*更新用户头像 */
  static Future<ServiceResult> uploadImage(Uint8List uint8list) async {
    List<int> data = uint8list;
    ServiceResult serviceResult = ServiceResult();
    var uri = Uri.parse("${netUrl.bitnetUrl}user/uploadImage.do");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'package',
          data,
        ),
      );
    request.headers.addAll(ServiceTokenHead.headMap!);
    var response = await request.send();
    if (response.statusCode == 401) {
      istokentimeout(statefunctionServiceResult(serviceResult));
    }
    if (response.statusCode == 200) {
      Map<String, String> map = response.headers;
      serviceResult.success = true;
      serviceResult.msg = map["image"].toString();
    }
    return serviceResult;
  }

  /*获取个人用户动态列表 */
  static Future<ServiceResultData> getUserDynamic() async {
    ServiceResultData resultData = ServiceResultData();
    ServiceResultData<List<DynamicModel>> resultData1 = ServiceResultData();
    var url = await http.get(
        Uri.parse("${netUrl.bitnetUrl}user/getUserDynamic.do"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
      resultData1.code = url.statusCode;
      if (resultData.success) {
        List<DynamicModel> newresultData = [];
        List<dynamic> resdata = resultData.data!;
        for (int i = 0; i < resdata.length; i++) {
          var fdata = DynamicModel.fromJson(resdata[i]);
          newresultData.add(fdata);
        }
        resultData1.data = newresultData;

        resultData1.success = resultData.success;
        resultData1.msg = resultData.msg;
      }
    }
    return resultData1;
  }

  /*获取个人用户动态列表 */
  static Future<ServiceResultData> getUserDynamicx(String? account) async {
    ServiceResultData resultData = ServiceResultData();
    ServiceResultData<List<DynamicModel>> resultData1 = ServiceResultData();
    var url = await http.get(
        Uri.parse(
            "${netUrl.bitnetUrl}user/getUserDynamicx.do?account=$account"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
      resultData1.code = url.statusCode;
      if (resultData.success) {
        List<DynamicModel> newresultData = [];
        List<dynamic> resdata = resultData.data!;
        for (int i = 0; i < resdata.length; i++) {
          var fdata = DynamicModel.fromJson(resdata[i]);
          newresultData.add(fdata);
        }
        resultData1.data = newresultData;

        resultData1.success = resultData.success;
        resultData1.msg = resultData.msg;
      }
    }
    return resultData1;
  }

  /*查询个人收藏*/
  static Future<ServiceResultData> getUserCollectionList() async {
    ServiceResultData resultData = ServiceResultData();
    ServiceResultData<List<CollectionModel>> serviceResultData =
        ServiceResultData();
    var url = await http.get(
        Uri.parse("${netUrl.bitnetUrl}user/getUserCollectionList.do"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
      serviceResultData.code = url.statusCode;
      List<CollectionModel> newdata = [];
      if (resultData.success) {
        for (int i = 0; i < resultData.data.length; i++) {
          var fdata = CollectionModel.fromJson(resultData.data[i]);
          newdata.add(fdata);
        }
        serviceResultData.data = newdata;
        serviceResultData.success = resultData.success;
        serviceResultData.msg = resultData.msg;
      }
    }

    return serviceResultData;
  }

  /*获取用户消息列表 */
  static Future<ServiceResultData> getUserMessageList(String account) async {
    ServiceResultData resultData = ServiceResultData();
    ServiceResultData<List<MessageModel>> serviceResultData =
        ServiceResultData();
    var url = await http.get(
        Uri.parse(
            "${netUrl.bitnetUrl}user/getUserMessageList.do?account=$account"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
      serviceResultData.code = url.statusCode;
      List<MessageModel> newdata = [];
      if (resultData.success) {
        for (int i = 0; i < resultData.data.length; i++) {
          var fdata = MessageModel.fromJson(resultData.data[i]);
          newdata.add(fdata);
        }
        serviceResultData.data = newdata;

        serviceResultData.success = resultData.success;
        serviceResultData.msg = resultData.msg;
      }
    }

    return serviceResultData;
  }

  /*获取用户消息列表  使用account*/
  static Future<ServiceResultData> getUserMessageListx(String account) async {
    ServiceResultData resultData = ServiceResultData();
    ServiceResultData<List<MessageModel>> serviceResultData =
        ServiceResultData();
    var url = await http.get(
        Uri.parse(
            "${netUrl.bitnetUrl}user/getUserMessageListx.do?account=$account"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
      serviceResultData.code = url.statusCode;
      List<MessageModel> newdata = [];
      if (resultData.success) {
        for (int i = 0; i < resultData.data.length; i++) {
          var fdata = MessageModel.fromJson(resultData.data[i]);
          newdata.add(fdata);
        }
        serviceResultData.data = newdata;

        serviceResultData.success = resultData.success;
        serviceResultData.msg = resultData.msg;
      }
    }

    return serviceResultData;
  }

  /*获取用户之间的关系 */
  static Future<ServiceResultData> getUserRelation(String account) async {
    ServiceResultData resultData = ServiceResultData();
    var url = await http.get(
        Uri.parse("${netUrl.bitnetUrl}user/getUserRelation.do?you=$account"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
    }
    return resultData;
  }

  /*修改用户之间的关系*/
  static Future<ServiceResultData> getXGRelation(String account, bool b) async {
    ServiceResultData resultData = ServiceResultData();
    var url = await http.post(
        Uri.parse("${netUrl.bitnetUrl}user/getXGRelation.do"),
        body: {'you': account, 'isgz': b.toString()},
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
    }
    return resultData;
  }

  /*获取用户动态的评论 */
  static Future<ServiceResultData> getDynamicMessageList(String dyid) async {
    ServiceResultData resultData = ServiceResultData();
    ServiceResultData<List<MessageModel>> serviceResultData =
        ServiceResultData();
    var url = await http.get(
        Uri.parse(
            "${netUrl.bitnetUrl}user/getDynamicMessageList.do?dyid=$dyid"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
      serviceResultData.code = url.statusCode;
      List<MessageModel> newdata = [];
      if (resultData.success) {
        for (int i = 0; i < resultData.data.length; i++) {
          var fdata = MessageModel.fromJson(resultData.data[i]);
          newdata.add(fdata);
        }
        serviceResultData.data = newdata;
        serviceResultData.success = resultData.success;
        serviceResultData.msg = resultData.msg;
      }
    }
    return serviceResultData;
  }

  /*获取用户头像·  使用id */
  static Future<ServiceResultData> getUserDynamicImgById(String id) async {
    ServiceResultData resultData = ServiceResultData();
    var url = await http.get(
        Uri.parse("${netUrl.bitnetUrl}user/getUserDynamicImg.do?id=$id"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
    }
    return resultData;
  }

  /* 使用id获取动态数据*/
  static Future<ServiceResultData> getUserDynamicById(String id) async {
    ServiceResultData resultData = ServiceResultData();
    ServiceResultData<DynamicModel> resultData1 = ServiceResultData();
    var url = await http.get(
        Uri.parse("${netUrl.bitnetUrl}user/getUserDynamicById.do?id=$id"),
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResultData(resultData));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      resultData = ServiceResultData.fromJson(data);
      resultData1.code = url.statusCode;
      if (resultData.success) {
        resultData1.data = DynamicModel.fromJson(resultData.data);
        resultData1.success = resultData.success;
        resultData1.msg = resultData.msg;
      }
    }
    return resultData1;
  }

  /* 使用id获取动态数据*/
  static Future<ServiceResult> addDynamicMessage(
      String dyid, String body) async {
    ServiceResult result = ServiceResult();
    var url = await http.post(
        Uri.parse("${netUrl.bitnetUrl}user/addDynamicMessage.do"),
        body: {'dyid': dyid, 'body': body},
        headers: ServiceTokenHead.headMap);
    if (url.statusCode == 401) {
      istokentimeout(statefunctionServiceResult(result));
    }
    if (url.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(url.body);
      result = ServiceResultData.fromJson(data);
    }
    return result;
  }
  //

  /* 发布动态*/
  static Future<ServiceResultData> addDynamicDetail(
      List<File> files, String title, String body) async {
    ServiceResultData resultData = ServiceResultData();
    List<http.MultipartFile> files1 = [];
    try {
      for (int i = 0; i < files.length; i++) {
        Uint8List uint8list = await files[i].readAsBytes();
        //http.MultipartFile.fromBytes("data", uint8list);
        files1.add(http.MultipartFile.fromBytes("data", uint8list));
      }
      files1.add(http.MultipartFile.fromString("title", title));
      files1.add(http.MultipartFile.fromString("body", body));
    } catch (e) {
      print(e);
    }

    var uri = Uri.parse("${netUrl.bitnetUrl}user/addDynamicDetail.do");
    var request = http.MultipartRequest('POST', uri)..files.addAll(files1);
    request.headers.addAll(ServiceTokenHead.headMap!);
    var response = await request.send();
    if (response.statusCode == 401) {
      istokentimeout(statefunctionServiceResult(resultData));
    }
    if (response.statusCode == 200) {
      resultData.success = true;
    }
    return resultData;
  }
}
