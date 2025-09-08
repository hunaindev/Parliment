import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/services/child_location_service.dart';
import 'package:parliament_app/src/features/auth/data/data_sources/user_remote_datasource.dart';
import 'package:parliament_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:parliament_app/src/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:parliament_app/src/features/auth/domain/usecase/user_usecase.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'package:parliament_app/src/features/child-home/data/remote_data_source/get_children_dashboard_remote_data_source.dart';
import 'package:parliament_app/src/features/child-home/data/remote_data_source/get_children_dashboard_remote_data_source_impl.dart';
import 'package:parliament_app/src/features/child-home/data/respositories/child_dashboard_repository_impl.dart';
import 'package:parliament_app/src/features/child-home/domain/repositories/child_dashboard_repository.dart';
import 'package:parliament_app/src/features/family_management/data/data_sources/member_remote_data_source.dart';
import 'package:parliament_app/src/features/family_management/data/repostories/member_repostory_impl.dart';
import 'package:parliament_app/src/features/family_management/domain/repositories/member_repository.dart';
import 'package:parliament_app/src/features/family_management/domain/usecases/add_member_usecase.dart';
import 'package:parliament_app/src/features/family_management/domain/usecases/delete_member_usecase.dart';
import 'package:parliament_app/src/features/family_management/domain/usecases/edit_member_usecase.dart';
import 'package:parliament_app/src/features/family_management/domain/usecases/get_member_usecase.dart';
import 'package:parliament_app/src/features/family_management/presentations/blocs/member_bloc.dart';
import 'package:parliament_app/src/features/history_reports/data/data_sources/notification_remote_data_source.dart';
// import 'package:parliament_app/src/features/history_reports/data/data_sources/report_remote_data_source.dart';
import 'package:parliament_app/src/features/history_reports/data/repositories/notification_repository_impl.dart';
// import 'package:parliament_app/src/features/history_reports/data/repositories/report_repository_impl.dart';
import 'package:parliament_app/src/features/history_reports/domain/repositories/notification_repository.dart';
// import 'package:parliament_app/src/features/history_reports/domain/repositories/report_repository.dart';
import 'package:parliament_app/src/features/home/data/data_source/get_dashboard_remote_source.dart';
import 'package:parliament_app/src/features/home/data/data_source/get_dashboard_remote_source_impl.dart';
import 'package:parliament_app/src/features/home/data/data_source/offender_remote_source.dart';
import 'package:parliament_app/src/features/home/data/data_source/offender_remote_source_impl.dart';
import 'package:parliament_app/src/features/home/data/respositories/dashboard_repository_impl.dart';
import 'package:parliament_app/src/features/home/data/respositories/offender_repository_impl.dart';
import 'package:parliament_app/src/features/home/domain/repositories/dashboard_repository.dart';
import 'package:parliament_app/src/features/home/domain/repositories/offender_repository.dart';

import 'package:parliament_app/src/features/safety_tools/data/data_sources/geofence_remote_datasource.dart';
import 'package:parliament_app/src/features/safety_tools/data/data_sources/restricted_zone_remote_datasource.dart';
import 'package:parliament_app/src/features/safety_tools/domain/repositories/geofence_repository.dart';
import 'package:parliament_app/src/features/safety_tools/domain/repositories/geofence_repository_impl.dart';
import 'package:parliament_app/src/features/safety_tools/domain/repositories/restricted_zone_repository.dart';
import 'package:parliament_app/src/features/safety_tools/domain/repositories/restricted_zone_repository_impl.dart';
import 'package:parliament_app/src/features/safety_tools/domain/usecases/create_geofence_usecase.dart';
import 'package:parliament_app/src/features/safety_tools/domain/usecases/restricted_zone_usecase.dart';
import 'package:parliament_app/src/features/safety_tools/presentations/blocs/restricted_zone_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Register http client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Register RemoteDataSource using the concrete implementation
  getIt.registerLazySingleton<GeofenceRemoteDataSource>(
    () => GeofenceRemoteDataSourceImpl(client: getIt<http.Client>()),
  );

  // Register Repository
  getIt.registerLazySingleton<GeofenceRepository>(
    () => GeofenceRepositoryImpl(
        remoteDataSource: getIt<GeofenceRemoteDataSource>()),
  );

  // Register UseCase
  getIt.registerLazySingleton<CreateGeofenceUseCase>(
    () => CreateGeofenceUseCase(getIt<GeofenceRepository>()),
  );
  getIt.registerLazySingleton<RoleCubit>(() => RoleCubit());

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: http.Client(),
      roleCubit: getIt<RoleCubit>(), // ✅ use the registered singleton
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<SignupUseCase>(
      () => SignupUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<LinkChildUseCase>(
      () => LinkChildUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<ChooseRoleUseCase>(
      () => ChooseRoleUseCase(getIt<AuthRepository>()));

  getIt.registerLazySingleton<ChildLocationService>(
      () => ChildLocationService());

// --- Family Management (Member) Setup ---

// Remote Data Source
  getIt.registerLazySingleton<MemberRemoteDataSource>(
    () => MemberRemoteDataSourceImpl(getIt<http.Client>()),
  );

// Repository
  getIt.registerLazySingleton<MemberRepository>(
    () => MemberRepositoryImpl(getIt<MemberRemoteDataSource>()),
  );

// Use Cases
  getIt.registerLazySingleton<GetMembersUseCase>(
    () => GetMembersUseCase(getIt<MemberRepository>()),
  );
  getIt.registerLazySingleton<AddMemberUseCase>(
    () => AddMemberUseCase(getIt<MemberRepository>()),
  );
  getIt.registerLazySingleton<DeleteMemberUseCase>(
    () => DeleteMemberUseCase(getIt<MemberRepository>()),
  );
  getIt.registerLazySingleton<EditMemberUseCase>(
    () => EditMemberUseCase(getIt<MemberRepository>()),
  );

// Bloc
  getIt.registerFactory<MemberBloc>(
    () => MemberBloc(
      getMembersUseCase: getIt<GetMembersUseCase>(),
      addMemberUseCase: getIt<AddMemberUseCase>(),
      deleteMemberUseCase: getIt<DeleteMemberUseCase>(),
      editMemberUseCase: getIt<EditMemberUseCase>(),
    ),
  );

  getIt.registerLazySingleton<OffenderRemoteDataSource>(
    () =>
        OffenderRemoteDataSourceImpl(), // Replace with your actual implementation
  );

  // ✅ Register OffenderRepository
  getIt.registerLazySingleton<OffenderRepository>(
    () => OffenderRepositoryImpl(getIt<OffenderRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetDashboardRemoteSource>(
    () =>
        GetDashboardRemoteSourceImpl(), // Replace with your actual implementation
  );

  // ✅ Register PARENT DASHBOARD
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(getIt<GetDashboardRemoteSource>()),
  );

  getIt.registerLazySingleton<GetChildrenDashboardRemoteDataSource>(
    () =>
        GetChildrenDashboardRemoteDataSourceImpl(), // Replace with your actual implementation
  );

  // ✅ Register PARENT DASHBOARD
  getIt.registerLazySingleton<ChildDashboardRepository>(
    () => ChildDashboardRepositoryImpl(
        getIt<GetChildrenDashboardRemoteDataSource>()),
  );

// --------------- Restricted Zone Setup ----------------
  getIt.registerLazySingleton<RestrictedZoneRemoteDatasource>(
    () => RestrictedZoneRemoteDataSourceImpl(client: getIt<http.Client>()),
  );
  getIt.registerLazySingleton<RestrictedZoneRepository>(
    () => RestrictedZoneRepositoryImpl(
        remoteDataSource: getIt<RestrictedZoneRemoteDatasource>()),
  );
  getIt.registerLazySingleton<CreateRestrictedZoneUseCase>(
    () => CreateRestrictedZoneUseCase(getIt<RestrictedZoneRepository>()),
  );
  getIt.registerFactory<RestrictedZoneBloc>(
    () => RestrictedZoneBloc(
        createRestrictedZoneUseCase: getIt<CreateRestrictedZoneUseCase>()),
  );
// Register remote data source first
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSource());

// Then register repository, injecting the remoteDataSource
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt<NotificationRemoteDataSource>()),
  );
}
