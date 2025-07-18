// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as String,
      uid: json['uid'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      hexColor: _colorFromJson(json['hexColor'] as String),
      dueAt: _dateTimeFromJson(json['dueAt'] as String),
      createdAt: _dateTimeFromJson(json['createdAt'] as String),
      updatedAt: _dateTimeFromJson(json['updatedAt'] as String),
      isSynced: (json['isSynced'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'hexColor': _colorToJson(instance.hexColor),
      'dueAt': _dateTimeToJson(instance.dueAt),
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedAt': _dateTimeToJson(instance.updatedAt),
      'isSynced': instance.isSynced,
    };
