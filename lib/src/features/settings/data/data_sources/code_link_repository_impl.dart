// data/repositories/link_repository_impl.dart

// import 'package:parliament_app/src/features/link/domain/repositories/link_repository.dart';
// import 'package:parliament_app/src/features/settings/data/data_sources/remote/code_link_remote_datasource.dart';
// import '../datasources/link_remote_datasource.dart';

import 'package:parliament_app/src/features/settings/data/data_sources/remote/code_link_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/domain/repositories/code_link_repository.dart';

class LinkRepositoryImpl implements LinkRepository {
  final LinkRemoteDataSource remote;

  LinkRepositoryImpl(this.remote);

  @override
  Future<String> generateCode() => remote.generateCode();

  @override
  Future<bool> verifyCode(String code) => remote.verifyCode(code);
}
