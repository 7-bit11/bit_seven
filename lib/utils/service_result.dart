class ServiceTokenHead {
  static Map<String, String>? headMap;
  static void initializationHead(String token) {
    headMap = {'token': token};
  }
}

/// <summary>
/// 服务返回的通用数据包
/// </summary>
class ServiceResultData<T> extends ServiceResult {
  ServiceResultData({super.success, super.code, super.msg, this.data});

  /// <summary>
  /// 请求成功的数据
  /// </summary>
  late T? data;

  /// 因为调用 jsonDecode 把 json 串转对象时，jsonDecode 方法的返回值是 map 类型，无法直接转成 Student 对象
  factory ServiceResultData.fromJson(Map<String, dynamic> parsedJson) {
    return ServiceResultData<T>(
      data: parsedJson['data'],
      success: parsedJson['success'],
      msg: parsedJson['msg'],
      code: parsedJson['code'],
    );
  }
}

/// <summary>
/// 服务返回的通用消息包
/// </summary>
class ServiceResult {
  ServiceResult({this.success = false, this.code = 400, this.msg = ""});

  /// <summary>
  /// 当前请求是否成功
  /// </summary>
  bool success = false;

  /// <summary>
  /// 当前请求的消息
  /// </summary>
  String msg = "";

  /// <summary>
  /// HTTP请求状态码 HttpStatusCode
  /// </summary>
  int code = 0;

  /// <summary>
  /// 页面数据
  /// </summary>
  //late ServiceResultPage pageMata;

  /// 因为调用 jsonDecode 把 json 串转对象时，jsonDecode 方法的返回值是 map 类型，无法直接转成 Student 对象
  factory ServiceResult.fromJson(Map<String, dynamic> parsedJson) {
    return ServiceResult(
      success: parsedJson['success'],
      msg: parsedJson['msg'],
      code: parsedJson['code'],
    );
  }
}

class ServiceResultPage {
  late int pageIndex;
  late int pageSize;
  late int total;
}
