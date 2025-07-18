// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskParam _$TaskParamFromJson(Map<String, dynamic> json) => TaskParam(
      title: json['title'] as String?,
      description: json['description'] as String?,
      hexColor: _colorFromJson(json['hexColor'] as String),
      dueAt: _dateTimeFromJson(json['dueAt'] as String?),
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$TaskParamToJson(TaskParam instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'uid': instance.uid,
      'hexColor': _colorToJson(instance.hexColor),
      'dueAt': _dateTimeToJson(instance.dueAt),
    };
