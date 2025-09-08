import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/widgets/drawer_widget.dart';
import 'package:parliament_app/src/core/widgets/header_widget.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MainScaffold extends StatefulWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool isMapScreen;

  const MainScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.isMapScreen = false,
  });

  @override
  MainScaffoldState createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    final userDetails = await LocalStorage.getUser();
    final role = await LocalStorage.getRole();
    print("userDetails ${userDetails}");
    if (userDetails != null) {
      context.read<UserCubit>().setUser(userDetails);
      context.read<RoleCubit>().chooseRole(role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: widget.isMapScreen,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        scrollController: widget.isMapScreen ? null : _scrollController,
        isMapScreen: widget.isMapScreen,
      ),
      backgroundColor:
          widget.isMapScreen ? Colors.transparent : const Color(0xFFF5F7FA),
      drawer: const DrawerWidget(),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: widget.isMapScreen
          ? widget.body
          : SingleChildScrollView(
              controller: _scrollController,
              child: widget.body,
            ),
    );
  }
}
