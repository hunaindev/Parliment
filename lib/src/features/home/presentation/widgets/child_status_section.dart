import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
// import 'package:parliament_app/src/features/home/cubit/child_location_cubit.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/child_status_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../settings/data/data_sources/code_link_repository_impl.dart';
import '../../../settings/data/data_sources/remote/code_link_remote_datasource.dart';
import '../../../settings/domain/usercases/link_code_usecase.dart';
import '../../../settings/domain/usercases/verify_code_usecase.dart';
import '../../../settings/presentations/blocs/code_generator_cubit.dart';
import '../../../settings/presentations/widgets/generate_code_bottom_sheet.dart';

class ChildStatusSection extends StatelessWidget {
  const ChildStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildLocationCubit, List<ChildInfo>>(
      builder: (context, children) {
        if (children.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to the linking page
                  // Navigator.pushNamed(context, '/link-children');
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return BlocProvider(
                        create: (_) => LinkCubit(
                          generateCodeUseCase: GenerateCodeUseCase(
                              LinkRepositoryImpl(LinkRemoteDataSource())),
                          verifyCodeUseCase: VerifyCodeUseCase(
                              LinkRepositoryImpl(LinkRemoteDataSource())),
                        ),
                        child: FractionallySizedBox(
                            child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: const GenerateCodeBottomSheet(),
                        )),
                      );
                    },
                  );
                },
                child: const Text(
                  "Link to Children First",
                  style: TextStyle(
                      fontSize: 16, color: AppColors.primaryLightGreen),
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: children.map((child) {
              return ChildStatusCard(
                name: child.name,
                location: child.location ?? const LatLng(0.0, 0.0),
                locationStatus: Colors.yellow,
                status: child.isOnline ? "Online" : "Offline",
                statusColor: child.isOnline ? Colors.green : Colors.red,
                imageUrl: child.image ?? "",
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
