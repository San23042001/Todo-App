import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/services/sp_service.dart';
import 'package:todo_app/data/data_source/auth/auth_local_repository.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/domain/entities/user_param.dart';
import 'package:todo_app/domain/repository/auth_repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final SpService spService;
  final AuthLocalRepository authLocalRepository;
  AuthCubit(this.authRepository, this.spService, this.authLocalRepository)
      : super(AuthInitial());

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRepository.getUserData();
      if (userModel != null) {
        await authLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  void signUp(UserParam userParam) async {
    try {
      emit(AuthLoading());
      await authRepository.signUp(userParam);

      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login(UserParam userParam) async {
    try {
      emit(AuthLoading());
      final userModel = await authRepository.loginIn(userParam);

      if (userModel.token!.isNotEmpty) {
        await spService.setToken(userModel.token!);
      }

      await authLocalRepository.insertUser(userModel);

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
