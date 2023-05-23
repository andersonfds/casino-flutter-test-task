import 'package:casino_test/src/di/main_di_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'my_app.dart';

void main() {
  MainDIModule().configure(GetIt.I);
  runApp(const MyApp());
}
