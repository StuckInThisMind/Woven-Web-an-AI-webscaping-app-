import 'package:flutter/foundation.dart';
import 'api_service.dart';

class SearchState with ChangeNotifier {
  final List<String> _previousSearches = [];
  final ApiService _apiService = ApiService();
  bool _isSearching = false;

  List<String> get previousSearches => _previousSearches;
  bool get isSearching => _isSearching;

  Future<void> addSearch(String query) async {
    if (!_previousSearches.contains(query)) {
      _previousSearches.insert(0, query);
      notifyListeners();
    }
    
    _isSearching = true;
    notifyListeners();
    
    try {
      final success = await _apiService.initiateSearch(query);
      if (!success) {
        print('Failed to initiate search');
      }
    } catch (e) {
      print('Error during search: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<bool> checkSearchStatus() async {
    try {
      final status = await _apiService.checkSearchStatus();
      return status;
    } catch (e) {
      print('Error checking search status: $e');
      return false;
    }
  }
}