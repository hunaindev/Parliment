// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
// import 'package:parliament_app/src/core/bloc_observer.dart';
// import 'package:parliament_app/main.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/services/child_realtime_service.dart';
// import 'package:parliament_app/src/core/services/child_socket_service.dart';
// import 'package:parliament_app/src/core/services/unused_service/socket_client.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/svg_picture.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/navigation/navigation_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parliament_app/src/features/home/presentation/pages/notification_screen.dart';
// import 'package:parliament_app/src/features/home/presentation/pages/home_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // final String role;
  // final Function(int) onSelect;

  // int _selectedIndex = 0; // Track the selected tile

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<NavigationCubit>().state;
    final selectedRole = context.watch<RoleCubit>().state;

    print("selectedRole  ${selectedRole}");

    // Get current date
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(now);
    final user = context.read<UserCubit>().state;

    return Drawer(
      child: Column(
        children: [
          Padding(
            // height: 100,
            padding: const EdgeInsets.fromLTRB(16.0, 56.0, 16.0, 30.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLightGreen,
                    border: Border.all(
                      color: AppColors.darkGray,
                      width: 1,
                    ),
                    image: (user?.image != null && user!.image!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(user.image!), fit: BoxFit.cover)
                        : const DecorationImage(
                            image: AssetImage('assets/images/avatar.png'),
                            fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user?.name ?? 'Faseeh Hyder',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      text: formattedDate,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.darkBrown,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildListTile(
                  index: 0,
                  iconPath: 'assets/icons/home.svg',
                  title: 'Home',
                  onTileTap: () {
                    context.read<NavigationCubit>().selectIndex(0);
                    Navigator.pop(context);
                    if (selectedRole == "parent") {
                      //                       Navigator.push(
                      //   context,
                      //   PageRouteBuilder(
                      //     pageBuilder: (BuildContext context, Animation<double> animation1,
                      //         Animation<double> animation2) {
                      //       return ParentHomeScreen();
                      //     },
                      //     transitionDuration: Duration.zero,
                      //     reverseTransitionDuration: Duration.zero,
                      //   ),
                      // );

                      context.go(AppRoutes.parentHome);
                    } else {
                      context.go(AppRoutes.childHome);
                    }
                  },
                  selectedIndex: selectedIndex,
                ),
                ...[
                  if (selectedRole == "parent") ...[
                    _buildListTile(
                      index: 1,
                      iconPath: 'assets/icons/shield.svg',
                      title: 'Safety Tools',
                      width: 24,
                      height: 24,
                      onTileTap: () {
                        context.read<NavigationCubit>().selectIndex(1);
                        Navigator.pop(context);
                        context.push(AppRoutes.safetyTools);
                      },
                      selectedIndex: selectedIndex,
                    ),
                    _buildListTile(
                      index: 2,
                      iconPath: 'assets/icons/home-management.svg',
                      title: 'Family Management',
                      onTileTap: () {
                        context.read<NavigationCubit>().selectIndex(2);
                        Navigator.pop(context);
                        context.push(AppRoutes.familyManagement);
                      },
                      selectedIndex: selectedIndex,
                    ),
                    _buildListTile(
                      index: 3,
                      iconPath: 'assets/icons/home-management.svg',
                      title: 'Notification',
                      onTileTap: () {
                        context.read<NavigationCubit>().selectIndex(3);
                        Navigator.pop(context);
                        context.push(AppRoutes.notification);

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => NotificationScreen()));
                      },
                      selectedIndex: selectedIndex,
                    ),
                    _buildListTile(
                      index: 4,
                      iconPath: 'assets/icons/timer.svg',
                      title: 'History & Reports',
                      onTileTap: () {
                        context.read<NavigationCubit>().selectIndex(4);
                        Navigator.pop(context);
                        context.push(AppRoutes.historyReports);
                      },
                      selectedIndex: selectedIndex,
                    ),
                  ]
                ],
                _buildListTile(
                  index: 5,
                  iconPath: 'assets/icons/settings.svg',
                  title: 'Settings',
                  onTileTap: () {
                    context.read<NavigationCubit>().selectIndex(5);
                    context.push(AppRoutes.settings);
                    Navigator.pop(context);
                    // Add navigation logic
                  },
                  selectedIndex: selectedIndex,
                ),
              ],
            ),
          ),
          _buildListTile(
            index: 6,
            iconPath: 'assets/icons/logout.svg',
            title: 'Logout',
            onTileTap: () async {
              try {
                // --- SOCKET LOGOUT LOGIC ---

                // Get the current user BEFORE you clear storage
                final user = await LocalStorage.getUser();
                // final userId = user?.userId;

                // final user = context.read<UserCubit>().state;
                if (user != null) {
                  ChildRealtimeService().setChildOffline(
                    user.parentId.toString(),
                    user.userId.toString(),
                  );
                  context.read<AuthBloc>().add(
                        LogoutEvent(user.userId.toString()),
                      );
                }

                // 3. Google logout
                final GoogleSignIn _googleSignIn = GoogleSignIn();
                if (await _googleSignIn.isSignedIn()) {
                  await _googleSignIn.signOut();
                  print("✅ Google user signed out.");
                }

                // 4. Clear local storage
                await LocalStorage.clearUser();
                await LocalStorage.deleteRole();
                print("✅ Local storage cleared.");

                // 5. Reset app state (navigation and role)
                if (context.mounted) {
                  context.read<NavigationCubit>().selectIndex(0);
                  context.read<RoleCubit>().chooseRole(null);
                }

                // 6. Navigate to login
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              } catch (e) {
                print("❌ Logout error: $e");
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Logout failed: $e")),
                  );
                }
              }
            },
            selectedIndex: selectedIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required int index,
    required String iconPath,
    required String title,
    double? width,
    double? height,
    required VoidCallback onTileTap,
    required int selectedIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
          color: selectedIndex == index ? AppColors.primaryLightGreen : null,
          border: Border(
            bottom: BorderSide(
              color: selectedIndex == index
                  ? AppColors.primaryLightGreen
                  : Colors.grey.withOpacity(0),
              width: 1,
            ),
          ),
          borderRadius:
              selectedIndex == index ? BorderRadius.circular(5) : null,
        ),
        clipBehavior: selectedIndex == index ? Clip.hardEdge : Clip.none,
        child: ListTile(
          leading: title == "Notification"
              ? Icon(
                  Icons.notifications_rounded,
                  color: selectedIndex == index
                      ? Colors.white
                      : index == 3
                          ? null
                          : Colors.black,
                )
              : SvgPictureWidget(
                  path: iconPath,
                  color: selectedIndex == index
                      ? Colors.white
                      : index == 5
                          ? null
                          : Colors.black,
                  width: width ?? 20,
                  height: height ?? 20,
                ),
          title: TextWidget(
            text: title,
            fontWeight: FontWeight.bold,
            color: selectedIndex == index ? Colors.white : Colors.black,
            fontSize: 18,
          ),
          tileColor: Colors.transparent,
          onTap: onTileTap,
        ),
      ),
    );
  }
}
