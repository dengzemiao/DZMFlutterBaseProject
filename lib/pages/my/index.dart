import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';
import 'package:base_project/components/app_bar.dart';

class UserController extends BaseStatefulController {

  const UserController({super.key, super.title});

  @override
  UserControllerState createState() => UserControllerState();
}

class UserControllerState extends BaseStatefulControllerState {

  @override
  Widget? buildAppBar(BuildContext context, String? title) {
    return CustomAppBar(
      title: title,
      leftIcon: null,
    );
  }
}