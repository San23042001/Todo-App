import 'dart:convert';

import 'package:todo_app/core/constants/constants.dart';
import 'package:todo_app/core/network_api_service.dart';
import 'package:todo_app/core/services/sp_service.dart';
import 'package:todo_app/data/data_source/auth/auth_local_repository.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/domain/entities/user_param.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(UserParam userParam);
  Future<UserModel> logIn(UserParam userParam);
  Future<UserModel?> getUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkApiService networkApiService;
  final SpService spService;
  final AuthLocalRepository authLocalRepository;
  AuthRemoteDataSourceImpl(
      this.networkApiService, this.spService, this.authLocalRepository);
  @override
  Future<UserModel> logIn(UserParam userParam) async {
    final response = await networkApiService
        .post("${Constants.backendUri}/auth/login", body: userParam.toJson());
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> signUp(UserParam userParam) async {
    final response = await networkApiService
        .post("${Constants.backendUri}/auth/signup", body: userParam.toJson());
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }

      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/auth/tokenIsValid',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }

      final userResponse = await http.get(
        Uri.parse(
          '${Constants.backendUri}/auth',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (userResponse.statusCode != 200) {
        throw jsonDecode(userResponse.body)['error'];
      }
      return UserModel.fromJson(jsonDecode(userResponse.body));
    } catch (e) {
      final user = await authLocalRepository.getUser();
      return user;
    }
  }
}
