// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/svg_picture.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isMapScreen;
  final ScrollController? scrollController;

  const CustomAppBar({
    Key? key,
    this.scaffoldKey,
    this.isMapScreen = false,
    this.scrollController,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 20); // required

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final now = DateTime.now();
    final formattedDate = DateFormat('h:mm a | dd MMMM, yyyy').format(now);

    if (isMapScreen) {
      return Container(
        margin: EdgeInsets.only(top: 12, bottom: 10),
        // padding: EdgeInsets.only(bottom: 15),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 8,
          leadingWidth: 70,
          leading: _buildMenuButton(),
          title: _buildTitle(formattedDate),
          actions: [_buildProfileImage()],
        ),
      );
    }

    return AnimatedBuilder(
      animation: scrollController ?? ScrollController(),
      builder: (context, child) {
        final hasScrolled = (scrollController?.hasClients ?? false) &&
            (scrollController?.offset ?? 0) > 5;

        return Container(
          margin: EdgeInsets.only(top: 12, bottom: 10),
          // padding: EdgeInsets.only(bottom: 15),
          child: AppBar(
            backgroundColor: hasScrolled
                ? Colors.white.withOpacity(0.95)
                : Colors.transparent,
            elevation: hasScrolled ? 1 : 0,
            titleSpacing: 8,
            leadingWidth: 70,
            leading: _buildMenuButton(),
            title: _buildTitle(formattedDate),
            actions: [_buildProfileImage()],
          ),
        );
      },
    );
  }

  Widget _buildMenuButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Material(
        color: AppColors.primaryLightGreen,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            scaffoldKey?.currentState?.openDrawer();
          },
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: SvgPictureWidget(
              path: "assets/icons/menu.svg",
              color: Colors.white,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String formattedDate) {
    return BlocBuilder<UserCubit, UserEntity?>(
      builder: (context, user) {
        return Row(
          children: [
            SizedBox(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey ${user?.name ?? 'User'} 👋,',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Museo-Bolder',
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Museo-Bold',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage() {
    return BlocBuilder<UserCubit, UserEntity?>(
      builder: (context, user) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: (user?.image != null && user!.image!.isNotEmpty)
                  ? NetworkImage(user.image!) as ImageProvider
                  : const AssetImage('assets/images/avatar.png'),
              backgroundColor: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
