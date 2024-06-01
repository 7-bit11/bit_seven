// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
part 'personal_userModel.g.dart';

@JsonSerializable()
class User {
  User(
      this.userImgUrl,
      this.id,
      this.userName,
      this.userSex,
      this.birthday,
      this.province,
      this.city,
      this.town,
      this.occupation,
      this.account,
      this.fwiNumber,
      this.groupNumber,
      this.introduce,
      this.vmfbsNumber);
  late String userImgUrl; //头像
  late String userName; //名称
  late String userSex; //性别
  late DateTime birthday; //生日
  late String province; //省份
  late String city; //城市
  late String town; //区域
  late String occupation; //职业
  late String introduce; //个人介绍
  late String account;
  late int id;
  late int vmfbsNumber; //粉丝数
  late int fwiNumber; //关注数
  late int groupNumber; //群组数
  /* 反序列化 */
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /* 序列化 */
  Map<String, dynamic> toJson() => _$UserToJson(this);
  //map转换为User
  static User maptoUser(Map<String, Object?> map) {
    var userImgUrl = map["userImgUrl"];
    var id = map["id"];
    var userName = map["userName"];
    var userSex = map["userSex"];
    var birthday = map["birthday"];
    var province = map["province"];
    var city = map["city"];
    var town = map["town"];
    var occupation = map["occupation"];
    var account = map["account"];
    var fwiNumber = map["fwiNumber"];
    var groupNumber = map["groupNumber"];
    var introduce = map["introduce"];
    var vmfbsNumber = map["vmfbsNumber"];
    return User(
        userImgUrl as String,
        id! as int,
        userName as String,
        userSex as String,
        DateTime.parse(birthday as String),
        province as String,
        city as String,
        town as String,
        occupation as String,
        account as String,
        fwiNumber! as int,
        groupNumber! as int,
        introduce as String,
        vmfbsNumber! as int);
  }

  //user表名称
  static String mydataBase = "user.db";

  //user表结构
  static String sqlCreateusertable = "CREATE TABLE IF NOT EXISTS user("
      "id INTEGER PRIMARY KEY,"
      "userImgUrl TEXT,userName TEXT,"
      "userSex TEXT,birthday TEXT,"
      "province TEXT,city TEXT,town TEXT,"
      "occupation TEXT,"
      "introduce TEXT,account TEXT,"
      "vmfbsNumber INTEGER,"
      "fwiNumber INTEGER,groupNumber INTEGER"
      ")";
  //添加缓存sql
  static String getInsterSql(User user) {
    return
        // ignore: prefer_interpolation_to_compose_strings
        "INSERT INTO main.user (id, userImgUrl, userName, userSex, birthday, province, city, town, occupation, introduce, account, vmfbsNumber,"
                "fwiNumber,groupNumber) VALUES ('" +
            user.id.toString() +
            "','" +
            user.userImgUrl +
            "','" +
            user.userName +
            "','" +
            user.userSex +
            "','" +
            user.birthday.toString() +
            "','" +
            user.province +
            "','" +
            user.city +
            "','" +
            user.town +
            "','" +
            user.occupation +
            "','" +
            user.introduce +
            "','" +
            user.account +
            "','" +
            user.vmfbsNumber.toString() +
            "','" +
            user.fwiNumber.toString() +
            "','" +
            user.groupNumber.toString() +
            "');";
  }
}
