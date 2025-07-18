import 'package:todo_app/data/data_source/task/task_remote_data_source.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/domain/entities/task_param.dart';
import 'package:todo_app/domain/repository/task_repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource taskRemoteDataSource;

  TaskRepositoryImpl(this.taskRemoteDataSource);

  @override
  Future<TaskModel> createTask(TaskParam taskParam, String token) async {
    return await taskRemoteDataSource.createTask(taskParam, token);
  }

  @override
  Future<List<TaskModel>> getTasks(String token) async {
    return await taskRemoteDataSource.getTasks(token: token);
  }

  @override
  Future<bool> syncTasks(List<TaskModel> tasks, String token) async {
    return await taskRemoteDataSource.syncTasks(tasks, token);
  }
}
