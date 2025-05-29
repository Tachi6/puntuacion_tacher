import 'package:puntuacion_tacher/domain/entities/entities.dart';

abstract class MultipleRepository {

  Future<List<Multiple>> loadAllMultipleTaste();

  Future<Multiple> loadSingleMultipleTaste(String id);

  Future<Multiple> createMultipleTaste(Multiple multipleTaste);

  Future<void> updateMultipleTaste(String multipleId, WineTaste wineTaste);
  
  Future<void> updateAverageRatings(String multipleId, Map<String, AverageRatings> averageRatings);
}