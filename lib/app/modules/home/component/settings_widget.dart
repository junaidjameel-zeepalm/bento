import 'package:bento/app/data/constant/app_colors.dart';
import 'package:bento/app/modules/home/component/change_email_dialog.dart';
import 'package:bento/app/modules/home/component/change_username_dialog.dart';
import 'package:bento/app/modules/home/component/share_bento_dialog.dart';
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
                backgroundColor: Colors.white,
                titleStyle: AppTypography.kSemiBold16,
                title: '',
                content: const ShareBentoDialog()),
            child: Text('Share Profile', style: AppTypography.kRegular14)),
        PopupMenuItem(
            onTap: () => Get.defaultDialog(
                titleStyle: AppTypography.kSemiBold16,
                title: 'Change Username',
                content: ChangeUsernameDialog()),
            child: Text('Change Username', style: AppTypography.kRegular14)),
        PopupMenuItem(
            onTap: () => Get.defaultDialog(
                titleStyle: AppTypography.kSemiBold16,
                title: 'Change Email',
                content: ChangeEmailDialog()),
            child: Text('Change Email', style: AppTypography.kRegular14)),
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
