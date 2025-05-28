import 'package:puntuacion_tacher/domain/datasources/multiple_datasource.dart';
import 'package:puntuacion_tacher/domain/entities/multiple_new.dart';
import 'package:puntuacion_tacher/domain/entities/wine_taste.dart';
import 'package:puntuacion_tacher/domain/repositories/multiple_repository.dart';

class MultipleRepositoryImpl extends MultipleRepository {
  MultipleRepositoryImpl(this.multipleDatasource);

  final MultipleDatasource multipleDatasource;

  @override
  Future<MultipleNew> createMultipleTaste(MultipleNew multipleTaste) {
    return multipleDatasource.createMultipleTaste(multipleTaste);
  }

  @override
  Future<List<MultipleNew>> loadAllMultipleTaste() {
    return multipleDatasource.loadAllMultipleTaste();
  }

  @override
  Future<MultipleNew> loadSingleMultipleTaste(String id) {
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