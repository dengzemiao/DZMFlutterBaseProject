import 'package:flutter/material.dart';
import 'package:base_project/base/refresh/index.dart';

class HomeController extends BaseRefreshController {

  const HomeController({super.key, super.title});

  @override
  HomeControllerState createState() => HomeControllerState();
}

class HomeControllerState extends BaseRefreshControllerState with WidgetsBindingObserver {

}