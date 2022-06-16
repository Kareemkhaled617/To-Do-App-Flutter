import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../size_config.dart';
import '../theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      this.controller,
      required this.hint,
      this.widget,
      required this.title, this.readOnly=false})
      : super(key: key);
  final TextEditingController? controller;
  final String hint;
  final Widget? widget;
  final String title;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Text(title,
            style: Themes().titleStyle,),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 9,bottom: 5),
            padding:const EdgeInsets.only(left: 20),
            width: SizeConfig.screenWidth,
            height:55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child:Row(
              children: [
                Expanded(
                  child:  TextFormField(
                    readOnly: readOnly,
                    style: Themes().subTitleStyle,
                    cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.black,
                    showCursor: true,
                    autofocus: false,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle:Themes().subTitleStyle ,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:context.theme.backgroundColor,
                            width: 0,
                          )
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:context.theme.backgroundColor,
                            width: 0,
                          )
                      ),
                    ),
                  ),
                ),
                widget ??Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
