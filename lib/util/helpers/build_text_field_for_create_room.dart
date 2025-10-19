import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildTextFieldForCreateRoomImp(
    TextEditingController controller,
    String lable,
    String helper, [
    int max = 6,
  ]) {
    return TextField(
      controller: controller,
      maxLength: 1,
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        label: Text(
          lable,
          style: Get.textTheme.labelSmall!.copyWith(fontSize: 15),
        ),
        helper: Text(
          helper,
          style: Get.textTheme.labelSmall!.copyWith(fontSize: 15),
        ),
      ),
    );
  }