import 'package:flutter/material.dart';
import 'mobile/home_page_mobile.dart';
import 'tablet/home_page_tablet.dart';
import 'desktop/home_page_desktop.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    // Change UI direction based on orientation
    if(orientation == Orientation.portrait){
      return HomePageMobile(); // Phones and vertical tablets
    }else{
      if (width < 1024) return const HomePageTablet(); // Tablets in horizontal 
    return const HomePageDesktop(); // PC
  }
  }
}