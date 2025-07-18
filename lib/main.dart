import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/app.dart';
import 'package:todo_app/features/auth/cubit/auth_cubit.dart';
import 'package:todo_app/features/auth/cubit/bloc_observer.dart';
import 'package:todo_app/features/home/cubit/task_cubit.dart';
import 'package:todo_app/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();

  Bloc.observer = MyBlocObserver();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => sl<AuthCubit>()),
      BlocProvider(create: (_) => sl<TaskCubit>())
    ],
    child: const MyApp(),
  ));
}
