import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';

import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _taskController.getTask();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
            // NotifyHelper()
            //     .displayNotification(title: 'Theme Changed', body: 'NoThings');
            // NotifyHelper().initializeNotification();
          },
          icon: Icon(
              Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round),
          color: Get.isDarkMode ? Colors.white : Colors.black,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        width: double.maxFinite,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: Themes().subHeadStyle,
                    ),
                    Text(
                      'Today',
                      style: Themes().headStyle,
                    )
                  ],
                ),
                MyButton(
                  title: ' Add Task',
                  ontap: () async {
                    await Get.to(const AddTaskPage());
                    _taskController.getTask();
                  },
                  iconData: Icons.add,
                ),
              ],
            ),
            addDatePicker(),
            const SizedBox(
              height: 20,
            ),
            _showTask(context),
            // _noTaskMsg()
          ],
        ),
      ),
    );
  }

  Stack _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                        height: 6,
                      )
                    : const SizedBox(
                        height: 220,
                      ),
                SvgPicture.asset(
                  'images/task.svg',
                  color: Colors.blue,
                  width: 100,
                  height: 100,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'No Task Added yet ....No Task Added yet ...No Task Added yet ....',
                    style: Themes().subTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Expanded _showTask(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if(_taskController.taskList.isEmpty){
         return _noTaskMsg();
        } else {
          return ListView.builder(
            scrollDirection: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              var task = _taskController.taskList[index];

              var hour = task.startTime.toString().split(':')[0];
              var minutes = task.startTime.toString().split(':')[1];


              var date = DateFormat.jm().parse(task.startTime!);
              var myTime = DateFormat('HH:mm').format(date);

              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(':')[0]),
                int.parse(myTime.toString().split(':')[1]),
                task,
              );
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1300),
                child: SlideAnimation(
                  horizontalOffset: 300,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () => showBottomSheet(context, task),
                      child: TaskTile(task),
                    ),
                  ),
                ),
              );
            },
            itemCount: _taskController.taskList.length,
          );
        }
      }),
    );
  }

  Container addDatePicker() {
    return Container(
      //padding: const EdgeInsets.only(left: 5),
      child: DatePicker(
        _selectedDate,
        onDateChange: (nVal) {
          setState(() {
            _selectedDate = nVal;
          });
        },
        width: 60,
        height: 95,
        initialSelectedDate: _selectedDate,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 25, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
                child: Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            )),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task Completed',
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr),
            _buildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  _taskController.deleteTask(task);
                  Get.back();
                },
                clr: primaryClr),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? Themes().titleStyle
                : Themes().titleStyle.copyWith(
                      color: Colors.white,
                    ),
          ),
        ),
      ),
    );
  }
}
