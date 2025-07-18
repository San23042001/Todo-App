import 'package:json_annotation/json_annotation.dart';
part 'user_param.g.dart';

@JsonSerializable()
class UserParam {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "password")
  String? password;

  UserParam({this.email, this.name, this.password});

   factory UserParam.fromJson(Map<String, dynamic> json) =>
      _$UserParamFromJson(json);

  Map<String, dynamic> toJson() => _$UserParamToJson(this);
}
