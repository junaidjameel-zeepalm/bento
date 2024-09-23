import 'package:bento/app/data/constant/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/constant/app_typography.dart';
import '../../../repo/auth_repo.dart';
import 'change_password_dialog.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: AppColors.kWhite,
      icon: const Icon(CupertinoIcons.settings),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
            onTap: () => Get.defaultDialog(
                titleStyle: AppTypography.kSemiBold16,
                title: 'Change Password',
                content: const ChangePasswordDialog()),
            child: Text('Change Password', style: AppTypography.kRegular14)),
        PopupMenuItem(
            onTap: () => AuthRepo().signOut(),
            child: Text('Log Out', style: AppTypography.kRegular14)),
      ],
    );
  }
}
