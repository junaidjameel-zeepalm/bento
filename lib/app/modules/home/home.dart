import 'package:bento/app/modules/home/component/grid_section_widget.dart';
import 'package:bento/app/modules/home/component/widget_creation_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BentoHomePage extends StatefulWidget {
  const BentoHomePage({super.key});

  @override
  BentoHomePageState createState() => BentoHomePageState();
}

class BentoHomePageState extends State<BentoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const WidgetCreationTile(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 1300;
          return isMobile
              ? Center(child: _buildMobileLayout(isMobile))
              : _buildDesktopLayout(isMobile);
        },
      ),
    );
  }

  Widget _buildDesktopLayout(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Get.width * 0.25,
          child: _buildProfileSection(isMobile),
        ),
        SizedBox(
            width: Get.width * 0.75,
            child: GridSectionWidget(isMobile: isMobile)),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildProfileSection(isMobile),
          GridSectionWidget(isMobile: isMobile)
        ],
      ),
    );
  }

  Widget _buildProfileSection(bool isMobile) {
    return Padding(
      padding:
          EdgeInsets.only(left: isMobile ? 0.0 : 150, top: isMobile ? 30 : 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: isMobile ? 70 : 100,
            backgroundImage:
                const NetworkImage('https://i.imgur.com/BoN9kdC.png'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Character',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'CEO, Co-Founder at GTA Sand, LLC.\nSenior Game Engineer.',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
