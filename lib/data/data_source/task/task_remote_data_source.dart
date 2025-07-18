import 'package:todo_app/core/constants/constants.dart';
import 'package:todo_app/core/network_api_service.dart';
import 'package:todo_app/data/data_source/task/task_local_repository.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/domain/entities/task_param.dart';
import 'package:uuid/uuid.dart';

abstract class TaskRemoteDataSource {
  Future<TaskModel> createTask(TaskParam taskParam, String token);
  Future<List<TaskModel>> getTasks({required String token});
  Future<bool> syncTasks(List<TaskModel> tasks, String token);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final NetworkApiService networkApiService;
  final TaskLocalRepository taskLocalRepository;
  TaskRemoteDataSourceImpl(this.networkApiService, this.taskLocalRepository);

  @override
  Future<TaskModel> createTask(TaskParam taskParam, String token) async {
    try {
      final response = await networkApiService.post(
          "${Constants.backendUri}/tasks",
          headers: {'x-auth-token': token},
          body: taskParam.toJson());

      return TaskModel.fromJson(response);
    } catch (e) {
      try {
        final taskModel = TaskModel(
            id: const Uuid().v4(),
            uid: taskParam.uid!,
            title: taskParam.title!,
            description: taskParam.description!,
            hexColor: taskParam.hexColor,
            dueAt: taskParam.dueAt!,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: 0);
        await taskLocalRepository.insertTask(taskModel);
        return taskModel;
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<List<TaskModel>> getTasks({required String token}) async {
    try {
      final response = await networkApiService.get(
        "${Constants.backendUri}/tasks",
        headers: {'x-auth-token': token},
      );
      final listOfTasks = response;
      List<TaskModel> taskList = [];
      for (var elem in listOfTasks) {
        taskList.add(TaskModel.fromJson(elem));
      }
      await taskLocalRepository.insertTasks(taskList);
      return taskList;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }

  @override
  Future<bool> syncTasks(List<TaskModel> tasks, String token) async {
    try {
      final taskListMap = [];
      for (final task in tasks) {
        taskListMap.add(task.toJson());
      }
          await networkApiService.post(
        "${Constants.backendUri}/tasks/sync",
        headers: {'x-auth-token': token},
        body: taskListMap);

      return true;
    } catch (e) {
      return false;
    }
  }
}
