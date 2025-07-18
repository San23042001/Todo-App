import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/constants/utils.dart';
import 'package:todo_app/features/auth/cubit/auth_cubit.dart';
import 'package:todo_app/features/home/cubit/task_cubit.dart';
import 'package:todo_app/features/home/pages/add_new_task.dart';
import 'package:todo_app/features/home/widgets/date_selector.dart';
import 'package:todo_app/features/home/widgets/task_card.dart';
import 'package:todo_app/logger.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TaskCubit>().getTasks(user.user.token!);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        logInfo("Connectivity", "Hey Wifi is Connected");
        await context.read<TaskCubit>().syncTasks(user.user.token!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewTask.route());
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          )
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (state is TaskError) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is GetTaskSuccess) {
            final tasks = state.tasks
                .where((elem) =>
                    DateFormat('d').format(elem.dueAt) ==
                        DateFormat('d').format(selectedDate) &&
                    selectedDate.month == elem.dueAt.month &&
                    selectedDate.year == elem.dueAt.year)
                .toList();

            return Column(
              children: [
                DateSelector(
                  selectedDate: selectedDate,
                  onTap: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Row(
                          children: [
                            Expanded(
                              child: TaskCard(
                                color: task.hexColor,
                                headerText: task.title,
                                descriptionText: task.description,
                              ),
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: strengthenColor(
                                  task.hexColor,
                                  0.69,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                DateFormat.jm().format(task.dueAt),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                )
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
