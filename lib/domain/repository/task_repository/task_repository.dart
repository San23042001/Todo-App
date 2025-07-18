import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/domain/entities/task_param.dart';

abstract class TaskRepository {
  Future<TaskModel> createTask(TaskParam taskParam, String token);
  Future<List<TaskModel>> getTasks(String token);
   Future<bool> syncTasks(List<TaskModel> tasks, String token);
}
