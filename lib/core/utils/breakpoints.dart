import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile  = 600;
  static const double tablet  = 900;
  static const double desktop = 1024;

  static bool isMobile(BuildContext ctx)  => MediaQuery.of(ctx).size.width < mobile;
  static bool isTablet(BuildContext ctx)  { final w = MediaQuery.of(ctx).size.width; return w >= mobile && w < desktop; }
  static bool isDesktop(BuildContext ctx) => MediaQuery.of(ctx).size.width >= desktop;
}
