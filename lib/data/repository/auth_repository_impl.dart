import 'package:todo_app/data/data_source/auth/auth_remote_data_source.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/domain/entities/user_param.dart';
import 'package:todo_app/domain/repository/auth_repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<UserModel> loginIn(UserParam userParam) async {
    return await authRemoteDataSource.logIn(userParam);
  }

  @override
  Future<UserModel> signUp(UserParam userParam) async {
    return await authRemoteDataSource.signUp(userParam);
  }

  @override
  Future<UserModel?> getUserData() async {
    return await authRemoteDataSource.getUserData();
  }
}
