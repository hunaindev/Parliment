// domain/repositories/link_repository.dart

abstract class LinkRepository {
  Future<String> generateCode();
  Future<bool> verifyCode(String code);
}
