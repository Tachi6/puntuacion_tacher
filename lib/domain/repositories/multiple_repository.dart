import 'package:puntuacion_tacher/domain/entities/multiple_new.dart';
import 'package:puntuacion_tacher/domain/entities/wine_taste.dart';

abstract class MultipleRepository {

  Future<List<MultipleNew>> loadAllMultipleTaste();

  Future<MultipleNew> loadSingleMultipleTaste(String id);

  Future<MultipleNew> createMultipleTaste(MultipleNew multipleTaste);

  Future<void> updateMultipleTaste(String multipleId, WineTaste wineTaste);
  
  Future<void> updateAverageRatings(String multipleId, Map<String, AverageRatings> averageRatings);
}