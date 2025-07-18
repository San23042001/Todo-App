import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/data_source/task/task_local_repository.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/domain/entities/task_param.dart';
import 'package:todo_app/domain/repository/task_repository/task_repository.dart';
import 'package:todo_app/logger.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;
  final TaskLocalRepository taskLocalRepository;
  TaskCubit(this.taskRepository, this.taskLocalRepository)
      : super(TaskInitial());

  Future<void> createNewTask(TaskParam taskParam, String token) async {
    try {
      emit(TaskLoading());
      final taskModel = await taskRepository.createTask(taskParam, token);
      await taskLocalRepository.insertTask(taskModel);
      emit(AddTaskSuccess(taskModel));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> getTasks(String token) async {
    try {
      emit(TaskLoading());
      final tasks = await taskRepository.getTasks(token);
      emit(GetTaskSuccess(tasks));
    } catch (e) {
      logError("TaskCubitError", e.toString());
      emit(TaskError(e.toString()));
    }
  }

  Future<void> syncTasks(String token) async {
    //get all unsynced tasks from our sqlite db
    final unsyncedTasks = await taskLocalRepository.getUnsyncedTasks();
    if (unsyncedTasks.isEmpty) {
      return;
    }
    logInfo("Unsynced Task", "$unsyncedTasks");
    //talk to our postgresql db to add the new task
    final isSynced = await taskRepository.syncTasks(unsyncedTasks, token);
    //change the tasks that were added to the db from 0 to 1
    if (isSynced) {
      for (final task in unsyncedTasks) {
        logInfo("Task Synced", "Done....");
        taskLocalRepository.updatedRowValue(task.id, 1);
      }
    }
  }
}
