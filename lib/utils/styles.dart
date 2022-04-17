import 'package:flutter/cupertino.dart';
import 'package:poke/utils/colors.dart';

class Styles {

  static TextStyle get screenTitleTextStyle =>
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w800);

  static BoxDecoration get tabsBoxDecoration => const BoxDecoration(
      color: AppColors.gray700,
      borderRadius: BorderRadius.all(Radius.circular(8)));


  static BoxDecoration get tabsPagesBoxDecoration => const BoxDecoration(
      color: AppColors.gray100,
      borderRadius: BorderRadius.all(Radius.circular(8)));

  static BoxDecoration get indicatorBoxStyle =>  const BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.all(Radius.circular(8)));
}
