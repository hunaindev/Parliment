// domain/usecases/verify_code_usecase.dart

// import '../repositories/link_repository.dart';

import 'package:parliament_app/src/features/settings/domain/repositories/code_link_repository.dart';

class VerifyCodeUseCase {
  final LinkRepository repository;

  VerifyCodeUseCase(this.repository);

  Future<bool> call(String code) async {
    return await repository.verifyCode(code);
  }
}
