import 'package:flutter/material.dart';
import '../utils/breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  final Widget? tablet;
  const ResponsiveLayout({required this.mobile, required this.desktop, this.tablet, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= Breakpoints.desktop) return desktop;
      if (constraints.maxWidth >= Breakpoints.mobile)  return tablet ?? mobile;
      return mobile;
    });
  }
}
