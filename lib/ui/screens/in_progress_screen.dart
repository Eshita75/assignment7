import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';
import '../widgets/centered_progress_indicator.dart';
import '../widgets/show_snack_bar_message.dart';
import '../widgets/task_item.dart';

class InProgressScreen extends StatefulWidget {
  const InProgressScreen({super.key});

  @override
  State<InProgressScreen> createState() => _InProgressScreenState();
}

class _InProgressScreenState extends State<InProgressScreen> {
  bool _getinProgressTasks = false;
  List<TaskModel> inProgressTasks = [];

  @override
  void initState() {
    super.initState();
    _getProgressTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _getProgressTasks(),
        child: Visibility(
          visible: _getinProgressTasks == false,
          replacement: const CenteredProgressIndicator(),
          child: ListView.builder(
            itemCount: inProgressTasks.length,
            itemBuilder: (context, index) {
              return TaskItem(
                taskModel: inProgressTasks[index],
                onUpdateTask: () {
                  _getProgressTasks();
                }, statusColour: Colors.pink,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getProgressTasks() async {
    _getinProgressTasks = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.progressTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      inProgressTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Get Progress task failed! Try again');
      }
    }
    _getinProgressTasks = false;
    if (mounted) {
      setState(() {});
    }
  }
}
