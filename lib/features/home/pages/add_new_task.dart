import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/domain/entities/task_param.dart';
import 'package:todo_app/features/auth/cubit/auth_cubit.dart';
import 'package:todo_app/features/home/cubit/task_cubit.dart';
import 'package:todo_app/features/home/pages/home_page.dart';

class AddNewTask extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const AddNewTask(),
      );
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void createNewTask() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
      final taskParam = TaskParam(
        uid: user.user.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        hexColor: selectedColor,
        dueAt: selectedDate,
      );
      await context
          .read<TaskCubit>()
          .createNewTask(taskParam, user.user.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Task"),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            )),
        actions: [
          GestureDetector(
            onTap: () async {
              final _selectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 90),
                ),
              );
              if (_selectedDate != null && context.mounted) {
                setState(() {
                  selectedDate = _selectedDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat("d-MM-y").format(selectedDate),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is AddTaskSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Task added successfully"),
                ),
              );
              Navigator.pushAndRemoveUntil(
                  context, HomePage.route(), (_) => false);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Title cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Description cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ColorPicker(
                          heading: const Text("Select color"),
                          subheading: const Text("Select a different shade"),
                          onColorChanged: (Color color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          pickersEnabled: const {
                            ColorPickerType.wheel: true,
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: createNewTask,
                          child: const Text(
                            "SUBMIT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (state is AddTaskSuccess)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
