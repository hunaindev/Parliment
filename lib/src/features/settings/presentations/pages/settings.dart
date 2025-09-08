// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/code_link_repository_impl.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/code_link_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/delete_account_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/profile_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/reset_password_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/domain/repositories/delete_account_repository_impl.dart';
import 'package:parliament_app/src/features/settings/domain/repositories/reset_password_repository_impl.dart';
import 'package:parliament_app/src/features/settings/domain/repositories/user_repository_impl.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/delete_account_usecase.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/link_code_usecase.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/reset_password_usecase.dart';
import 'package:parliament_app/src/features/settings/domain/usercases/verify_code_usecase.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/code_generator_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/delete_account_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_bloc.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/reset_password_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/widgets/change_password.dart';
import 'package:parliament_app/src/features/settings/presentations/widgets/custom_info_tile.dart';
import 'package:parliament_app/src/features/settings/presentations/widgets/delete_account_modal.dart';
import 'package:parliament_app/src/features/settings/presentations/widgets/edit_profile.dart';
import 'package:parliament_app/src/features/settings/presentations/widgets/generate_code_bottom_sheet.dart';
import 'package:parliament_app/src/features/settings/presentations/widgets/link_code_bottom_sheet.dart';
import 'package:parliament_app/src/features/settings/presentations/widgets/privacy_policy.dart';
import 'package:parliament_app/src/features/settings/presentations/widgets/report_problem.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextWidget(
                text: "About",
                textAlign: TextAlign.left,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Museo-Bolder",
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    CustomInfoTile(
                      leading: Icon(
                        Icons.person,
                        color: AppColors.primaryLightGreen,
                      ),
                      title: 'Edit Profile',
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: false,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => BlocProvider(
                            create: (_) => ProfileBloc(
                                UserRepositoryImpl(ProfileRemoteDataSource())),
                            child: DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.63,
                              minChildSize: 0.4,
                              maxChildSize: 0.95,
                              builder: (_, scrollController) =>
                                  SingleChildScrollView(
                                controller: scrollController,
                                child: const EditProfileBottomSheet(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<RoleCubit, String?>(
                      builder: (context, role) {
                        if (role == 'parent') {
                          return CustomInfoTile(
                            leading: Icon(
                              Icons.link,
                              color: AppColors.primaryLightGreen,
                            ),
                            title: 'Generate Code to Link',
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return BlocProvider(
                                    create: (_) => LinkCubit(
                                      generateCodeUseCase: GenerateCodeUseCase(
                                          LinkRepositoryImpl(
                                              LinkRemoteDataSource())),
                                      verifyCodeUseCase: VerifyCodeUseCase(
                                          LinkRepositoryImpl(
                                              LinkRemoteDataSource())),
                                    ),
                                    child: FractionallySizedBox(
                                        child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 24),
                                      child: const GenerateCodeBottomSheet(),
                                    )),
                                  );
                                },
                              );
                            },
                          );
                        } else if (role == 'child') {
                          return CustomInfoTile(
                            leading: Icon(
                              Icons.link,
                              color: AppColors.primaryLightGreen,
                            ),
                            title: 'Link to Parent',
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return BlocProvider(
                                    create: (_) => LinkCubit(
                                      generateCodeUseCase: GenerateCodeUseCase(
                                          LinkRepositoryImpl(
                                              LinkRemoteDataSource())),
                                      verifyCodeUseCase: VerifyCodeUseCase(
                                          LinkRepositoryImpl(
                                              LinkRemoteDataSource())),
                                    ),
                                    child: FractionallySizedBox(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom, // handles keyboard
                                        ),
                                        child: const LinkCodeBottomSheet(),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    CustomInfoTile(
                      leading: Icon(
                        Icons.lock,
                        color: AppColors.primaryLightGreen,
                      ),
                      title: ('Reset Password'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          builder: (context) {
                            return BlocProvider(
                              create: (_) => ResetPasswordCubit(
                                resetPasswordUsecase: ResetPasswordUsecase(
                                  ResetPasswordRepositoryImpl(
                                    ResetPasswordRemoteDatasource(),
                                  ),
                                ),
                              ),
                              child: const FractionallySizedBox(
                                child: ChangePassword(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    CustomInfoTile(
                      leading: Icon(
                        Icons.delete,
                        color: AppColors.primaryLightGreen,
                      ),
                      title: ('Delete Account'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          builder: (context) {
                            return BlocProvider(
                              create: (_) => DeleteAccountCubit(
                                deleteAccountUsecase: DeleteAccountUsecase(
                                  DeleteAccountRepositoryImpl(
                                    DeleteAccountRemoteDatasource(),
                                  ),
                                ),
                              ),
                              child: DeleteAccountModal(),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextWidget(
                text: "Help & Support",
                textAlign: TextAlign.left,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Museo-Bolder",
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    CustomInfoTile(
                      leading: Icon(
                        Icons.bug_report,
                        color: AppColors.primaryLightGreen,
                      ),
                      title: ('Report Problem'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportProblem()));
                      },
                    ),
                    CustomInfoTile(
                      leading: Icon(
                        Icons.shield,
                        color: AppColors.primaryLightGreen,
                      ),
                      title: ('Privacy Policy '),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicyScreen()));
                      },
                    ),
                    CustomInfoTile(
                      leading: Icon(
                        Icons.info,
                        color: AppColors.primaryLightGreen,
                      ),
                      title: ('Visit our 1Parliament1 Website'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
