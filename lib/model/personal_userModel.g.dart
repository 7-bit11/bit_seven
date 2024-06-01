// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['headUrl'] as String,
      json['id'] as int,
      json['name'] as String,
      json['sex'] as String,
      DateTime.parse(json['birthday'] as String),
      json['province'] as String,
      json['city'] as String,
      json['town'] as String,
      json['occupation'] as String,
      json['account'] as String,
      json['fwiNumber'] as int,
      json['groupNumber'] as int,
      json['introduce'] as String,
      json['vmfbsNumber'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'headUrl': instance.userImgUrl,
      'name': instance.userName,
      'sex': instance.userSex,
      'birthday': instance.birthday.toIso8601String(),
      'province': instance.province,
      'city': instance.city,
      'town': instance.town,
      'occupation': instance.occupation,
      'introduce': instance.introduce,
      'account': instance.account,
      'id': instance.id,
      'vmfbsNumber': instance.vmfbsNumber,
      'fwiNumber': instance.fwiNumber,
      'groupNumber': instance.groupNumber,
    };
