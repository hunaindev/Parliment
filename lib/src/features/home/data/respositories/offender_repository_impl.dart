import 'package:parliament_app/src/features/home/domain/entities/offender_entity.dart';
import 'package:parliament_app/src/features/home/domain/repositories/offender_repository.dart';
import '../data_source/offender_remote_source.dart';

class OffenderRepositoryImpl implements OffenderRepository {
  final OffenderRemoteDataSource remoteDataSource;

  OffenderRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OffenderEntity>> fetchOffenders({
    required double lat,
    required double lng,
    required int page,
    required int pageSize,
  }) async {
    final models = await remoteDataSource.fetchOffenders(
      lat: lat,
      lng: lng,
      page: page,
      pageSize: pageSize,
    );

    return models
        .map((model) => OffenderEntity(
              name: model.name,
              address: model.address,
              city: model.city,
              state: model.state,
              zipCode: model.zipCode,
              location: model.location,
              gender: model.gender,
              age: model.age,
              eyeColor: model.eyeColor,
              hairColor: model.hairColor,
              height: model.height,
              weight: model.weight,
              marksScarsTattoos: model.marksScarsTattoos,
              courtRecord: model.courtRecord,
              photoUrl: model.photoUrl,
              image: model.photoUrl,
              updateDatetime: model.updateDatetime,
            ))
        .toList();
  }
}
