part of 'task_cubit.dart';

sealed class TaskState {
  const TaskState();
}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskError extends TaskState {
  final String error;

  TaskError(this.error);
}

final class AddTaskSuccess extends TaskState {
  final TaskModel taskModel;

  const AddTaskSuccess(this.taskModel);
}

final class GetTaskSuccess extends TaskState {
  final List<TaskModel> tasks;

  GetTaskSuccess(this.tasks);
}
