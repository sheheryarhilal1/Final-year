import 'package:final_year/Controller/Nav_bar_controller.dart';
import 'package:final_year/View/device.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  final NavBarController controller = Get.put(NavBarController());
  // final ThemeController themeController = Get.find<ThemeController>();

  final List<Widget> screens = [
    DevicesScreen(),
    DevicesScreen(),
    DevicesScreen(),
  ];

  NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Get.isDarkMode;

    return Obx(() {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Obx(() {
            // bool isDarkMode = themeController.isDarkMode.value;
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: isDark ? Colors.grey[900] : Colors.white,
              selectedItemColor: Color(0xFFADFF2F),
              unselectedItemColor: Colors.grey.shade400,
              selectedLabelStyle:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 10),
              iconSize: 30,
              onTap: (index) => controller.updateIndex(index),
              currentIndex: controller.currentIndex.value,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(Icons.home_rounded),
                  ),
                  label: "home".tr,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(Icons.devices_rounded),
                  ),
                  label: "device".tr,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(Icons.person),
                  ),
                  label: "me".tr,
                ),
              ],
            );
          }),
        ),
      );
    });
  }
}
