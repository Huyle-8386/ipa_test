import 'package:flutter/widgets.dart';

class SizeUtils {
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
