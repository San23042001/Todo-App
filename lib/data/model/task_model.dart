import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/core/constants/utils.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'uid')
  final String uid;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'hexColor', fromJson: _colorFromJson, toJson: _colorToJson)
  final Color hexColor;

  @JsonKey(name: 'dueAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime dueAt;

  @JsonKey(
      name: 'createdAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(
      name: 'updatedAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

   int? isSynced;

  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.hexColor,
    required this.dueAt,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = 1
    
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}

// Helper functions for color conversion
Color _colorFromJson(String hex) => hexToRgb(hex);
String _colorToJson(Color color) => rgbToHex(color);

// Helper functions for DateTime conversion
DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toUtc().toIso8601String();
