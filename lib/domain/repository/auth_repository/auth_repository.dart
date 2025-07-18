import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/domain/entities/user_param.dart';

abstract class AuthRepository {
  Future<UserModel> signUp(UserParam userParam);
  Future<UserModel> loginIn(UserParam userParam);
   Future<UserModel?> getUserData();
}
