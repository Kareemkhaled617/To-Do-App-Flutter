import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';

import '../../services/theme_services.dart';
import '../size_config.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime =
  DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
          },
          icon: Icon(
              Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('images/person.jpeg'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10, right: 2),
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            children: [
              Text(
                'Add Task',
                style: Themes().headStyle,
              ),
              InputField(
                hint: 'Title',
                title: 'Enter Task here',
                controller: _titleController,
              ),
              InputField(
                hint: 'Note',
                title: 'Enter note here',
                controller: _noteController,
              ),
              InputField(
                hint: DateFormat.yMd().format(_selectedDate),
                readOnly: true,
                title: 'Enter Date here',
                widget: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () => _getDateFromUser(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      readOnly: true,
                      hint: _startTime,
                      title: 'Start time',
                      widget: IconButton(
                        icon: const Icon(Icons.timer_outlined),
                        onPressed: ()=>_getTimeFromUser(isStartTime: true),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      readOnly: true,
                      hint: _endTime,
                      title: 'End time',
                      widget: IconButton(
                        icon: const Icon(Icons.timer_outlined),
                        onPressed: ()=>_getTimeFromUser(isStartTime: false),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                hint: '$_selectedRemind Min Early',
                title: 'Remind',
                readOnly: true,
                widget: DropdownButton(
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 35,
                  ),
                  items: remindList
                      .map((value) =>
                      DropdownMenuItem(value: value, child: Text('$value')))
                      .toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedRemind = value!;
                    });
                  },
                ),
              ),
              InputField(
                hint: _selectedRepeat,
                title: 'Repeat',
                readOnly: true,
                widget: DropdownButton(
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 35,
                  ),
                  items: repeatList
                      .map((value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildColumn(),
                  MyButton(
                    title: 'Create Task',
                    ontap: () {
                      _validateDate();
                      setState(() {
                        
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      children: [
        Text(
          'Color',
          style: Themes().headStyle,
        ),
        Row(
          children: List.generate(
              4,
                  (index) =>
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        child: _selectedColor == index
                            ? const Icon(
                          Icons.done,
                          size: 30,
                        )
                            : null,
                        backgroundColor: index == 0
                            ? Colors.red
                            : index == 1
                            ? Colors.cyan
                            : index == 2
                            ? Colors.teal
                            : Colors.deepOrangeAccent,
                        radius: 15,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                  )),
        )
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty ||
        _noteController.text.isEmpty) {
      Get.snackbar('required', 'All Field are Required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      print(' SomeThing Happened');
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: _selectedDate,
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat),
    );
    print(value);
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        lastDate: DateTime(2030),
        initialDate: _selectedDate,
        firstDate: DateTime(2010));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else {
      print('');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
            DateTime.now().add(const Duration(minutes: 15))),);
    String _formatedTime=_pickedTime!.format(context);

    if(isStartTime)
      setState(() {
        _startTime = _formatedTime;
      });
    else if(!isStartTime)
      setState(() {
        _endTime = _formatedTime;
      });
    else
      print('');
  }
}
