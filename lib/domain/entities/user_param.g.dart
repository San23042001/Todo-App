// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserParam _$UserParamFromJson(Map<String, dynamic> json) => UserParam(
      email: json['email'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserParamToJson(UserParam instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };
