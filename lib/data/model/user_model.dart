import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'token')
  String? token;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson,name: "createdAt")
  DateTime? createdAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson,name: "updatedAt")
  DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

// Custom DateTime conversion
DateTime? _dateTimeFromJson(String? date) => date != null ? DateTime.parse(date) : null;
String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();
