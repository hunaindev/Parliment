import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
import 'package:parliament_app/src/features/family_management/presentations/blocs/member_bloc.dart';
import 'package:parliament_app/src/features/family_management/presentations/blocs/member_event.dart';
import 'package:parliament_app/src/features/family_management/presentations/blocs/member_state.dart';
import 'package:parliament_app/src/features/family_management/presentations/widgets/family_management_card.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/widgets/add_member_modal.dart';

class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});

  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<MemberBloc>().add(LoadMembers()); // 🔥 Load on screen open
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            const TextWidget(
              text: 'Family Management',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
              fontFamily: "Museo-Bolder",
            ),
            const SizedBox(height: 10.0),

            /// ADD MEMBER BUTTON
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AddMemberDialog(
                      onCreate: (member) async{
                        context.read<MemberBloc>().add(AddMember(member));
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(128, 234, 243, 151),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: AppColors.primaryLightGreen,
                      width: 2,
                    ),
                  ),
                  elevation: 0,
                ),
                child: const TextWidget(
                  text: 'Add Member +',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Museo-Bold",
                  color: AppColors.primaryLightGreen,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BLoC BUILDER FOR LIST
            BlocBuilder<MemberBloc, MemberState>(
              builder: (context, state) {
                if (state is MemberLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.primaryLightGreen,
                  ));
                } else if (state is MemberError) {
                  return Center(child: Text("Error: ${state.message}"));
                } else if (state is MemberLoaded) {
                  if (state.members.isEmpty) {
                    return const TextWidget(
                      text: "No family members added yet.",
                      fontWeight: FontWeight.bold,
                    );
                  }

                  return Column(
                    children: state.members.map((member) {
                      return FamilyMemberCard(
                        member: member,
                        name: member.name,
                        onEdit: (updatedMember) async {
                          print(updatedMember);
                          context.read<MemberBloc>().add(EditMember(
                              memberId: member.memberId.toString(),
                              updatedMember: updatedMember)); // or ID
                        },
                        onDelete: () {
                          // print(member.memberId);
                          // 🔥 Dispatch delete
                          context.read<MemberBloc>().add(DeleteMember(
                              member.memberId.toString())); // or ID
                        },
                      );
                    }).toList(),
                  );
                }

                return const SizedBox(); // Initial or unknown state
              },
            ),
          ],
        ),
      ),
    );
  }
}
