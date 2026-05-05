import 'package:flutter/material.dart';
import 'package:flutter_hit_api/models/consultaion.dart';
import 'package:flutter_hit_api/services/api_service.dart';

class ConsultationProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  List<Consultation> _data = [];
  List<Consultation> get data => _data;
  bool isLoading = false;

  Future<void> fetchConsultation() async {
    isLoading = true;
    notifyListeners();
    try {
      _data = await apiService.getConsultation();
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> create(
    String name,
    DateTime date,
    String poli,
    String complaint,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      await apiService.createConsultation(name, date, poli, complaint);
      await fetchConsultation();
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> update(
    int id,
    String name,
    DateTime date,
    String poli,
    String complaint,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      await apiService.updateConsultation(id, name, date, poli, complaint);
      await fetchConsultation();
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> delete(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      await apiService.deleteData(id);
      await fetchConsultation();
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
