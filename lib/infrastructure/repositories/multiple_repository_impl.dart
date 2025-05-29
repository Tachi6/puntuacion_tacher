import 'package:puntuacion_tacher/domain/datasources/multiple_datasource.dart';
import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/domain/repositories/multiple_repository.dart';

class MultipleRepositoryImpl extends MultipleRepository {
  MultipleRepositoryImpl(this.multipleDatasource);

  final MultipleDatasource multipleDatasource;

  @override
  Future<Multiple> createMultipleTaste(Multiple multipleTaste) {
    return multipleDatasource.createMultipleTaste(multipleTaste);
  }

  @override
  Future<List<Multiple>> loadAllMultipleTaste() {
    return multipleDatasource.loadAllMultipleTaste();
  }

  @override
  Future<Multiple> loadSingleMultipleTaste(String id) {
    return multipleDatasource.loadSingleMultipleTaste(id);
  }

  @override
  Future<void> updateAverageRatings(String multipleId, Map<String, AverageRatings> averageRatings) {
    return multipleDatasource.updateAverageRatings(multipleId, averageRatings);
  }

  @override
  Future<void> updateMultipleTaste(String multipleId, WineTaste wineTaste) {
    return multipleDatasource.updateMultipleTaste(multipleId, wineTaste);
  }

}