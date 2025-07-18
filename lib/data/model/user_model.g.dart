// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['token'] as String?,
      createdAt: _dateTimeFromJson(json['createdAt'] as String?),
      updatedAt: _dateTimeFromJson(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedAt': _dateTimeToJson(instance.updatedAt),
    };
