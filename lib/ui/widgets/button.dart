import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key,required this.title, this.color,required this.ontap, this.iconData}) : super(key: key);
  final String title;
  final Color? color;
  final Function() ontap;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 140,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Get.isDarkMode ? Colors.grey :Colors.blueAccent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),
            Center(child: Text(title,style: Themes().titleStyle,)),
          ],
        ),
      ),
    );
  }
}
