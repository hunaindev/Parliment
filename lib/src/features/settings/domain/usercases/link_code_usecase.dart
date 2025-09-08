// domain/usecases/generate_code_usecase.dart

import 'package:parliament_app/src/features/settings/domain/repositories/code_link_repository.dart';


class GenerateCodeUseCase {
  final LinkRepository repository;

  GenerateCodeUseCase(this.repository);

  Future<String> call() async {
    return await repository.generateCode();
  }
}
