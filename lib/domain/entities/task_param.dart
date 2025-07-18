import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/core/constants/utils.dart';

part 'task_param.g.dart';

@JsonSerializable()
class TaskParam {
  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "description")
  String? description;

    @JsonKey(name: "uid")
  String? uid;


  @JsonKey(name: "hexColor", fromJson: _colorFromJson, toJson: _colorToJson)
 final  Color hexColor;

  @JsonKey(name: "dueAt", fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? dueAt;

  TaskParam({this.title, this.description,required this.hexColor, this.dueAt,this.uid});

  factory TaskParam.fromJson(Map<String, dynamic> json) =>
      _$TaskParamFromJson(json);

  Map<String, dynamic> toJson() => _$TaskParamToJson(this);
}

// Custom DateTime conversion
DateTime? _dateTimeFromJson(String? date) =>
    date != null ? DateTime.parse(date) : null;
String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();

Color _colorFromJson(String hex) => hexToRgb(hex);
String _colorToJson(Color color) => rgbToHex(color);
