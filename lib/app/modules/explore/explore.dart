import 'package:bento/app/data/constant/data.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Get inspired by the most creative Bentos.',
                  style: AppTypography.kBold28,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: OtherUsersProfileGrid(maxWidth: constraints.maxWidth),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OtherUsersProfileGrid extends StatelessWidget {
  final double maxWidth;

  const OtherUsersProfileGrid({
    super.key,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Define spacing between grid items
    const double spacing = 40.0;

    // Define breakpoints and the number of items per row for each device type
    int itemsPerRow;
    if (maxWidth > 1200) {
      // Web
      itemsPerRow = 4;
    } else if (maxWidth > 900) {
      // Tablet
      itemsPerRow = 3;
    } else if (maxWidth > 600) {
      // Small Tablet / Large Mobile
      itemsPerRow = 2;
    } else {
      // Mobile
      itemsPerRow = 2;
    }

    // Dynamically calculate the width of each item
    double itemWidth = (maxWidth - (itemsPerRow - 1) * spacing) / itemsPerRow;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(10, (index) {
        return Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: itemWidth,
            height: itemWidth * .55,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.kgrey),
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [ 
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: itemWidth * .1,
                ),
                const Spacer(),
                Text(
                  'Username',
                  style: AppTypography.kBold20,
                ),
                const SizedBox(height: 20),
              ],
            ));
      }),
    );
  }
}
