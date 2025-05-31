import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:interview/data/models/models.dart';

class VisitRepository {
  final http.Client _client = http.Client();
  final String _baseUrl = 'https://kqgbftwsodpttpqgqnbh.supabase.co/rest/v1';
  final String _apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtxZ2JmdHdzb2RwdHRwcWdxbmJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5ODk5OTksImV4cCI6MjA2MTU2NTk5OX0.rwJSY4bJaNdB8jDn3YJJu_gKtznzm-dUKQb4OvRtP6c';
  late Box<Customer> _customerBox;
  late Box<Activity> _activityBox;
  late Box<Visit> _visitBox;
  int _tempIdCounter = -1; // For temporary offline IDs

  Future<void> init() async {
    _customerBox = await Hive.openBox<Customer>('customers');
    _activityBox = await Hive.openBox<Activity>('activities');
    _visitBox = await Hive.openBox<Visit>('visits');
    await _syncOfflineVisits();
  }

  Future<List<Customer>> getCustomers() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      final response = await _client.get(
        Uri.parse('$_baseUrl/customers'),
        headers: {'apikey': _apiKey},
      );
      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        final customers = jsonList.map((json) => Customer.fromJson(json)).toList();
        await _customerBox.clear();
        await _customerBox.addAll(customers);
        return customers;
      }
      throw Exception('Failed to fetch customers: ${response.statusCode}');
    }
    return _customerBox.values.toList();
  }

  Future<List<Activity>> getActivities() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      final response = await _client.get(
        Uri.parse('$_baseUrl/activities'),
        headers: {'apikey': _apiKey},
      );
      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        final activities = jsonList.map((json) => Activity.fromJson(json)).toList();
        await _activityBox.clear();
        await _activityBox.addAll(activities);
        return activities;
      }
      throw Exception('Failed to fetch activities: ${response.statusCode}');
    }
    return _activityBox.values.toList();
  }

  Future<List<Visit>> getVisits() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      final response = await _client.get(
        Uri.parse('$_baseUrl/visits'),
        headers: {'apikey': _apiKey},
      );
      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;
        final visits = jsonList.map((json) => Visit.fromJson(json)).toList();
        await _visitBox.clear();
        await _visitBox.addAll(visits);
        return visits;
      }
      throw Exception('Failed to fetch visits: ${response.statusCode}');
    }
    return _visitBox.values.toList();
  }

  Future<void> addVisit(Visit visit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    // Assign a temporary ID if not provided
    final visitToSave = visit.id < 0 ? visit : visit.copyWith(id: _tempIdCounter--);
    await _visitBox.add(visitToSave);
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      await _syncVisit(visitToSave);
    }
  }

  Future<void> _syncVisit(Visit visit) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/visits'),
      headers: {
        'apikey': _apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(visit.toJson()),
    );
    print("response.statusCoderesponse.statusCode ${response.statusCode}");
    if (response.statusCode == 201) {
      final syncedVisit = Visit.fromJson(jsonDecode(response.body));
      await _visitBox.put(syncedVisit.id, syncedVisit.copyWith(isSynced: true));
    } else {
      throw Exception('Failed to sync visit: ${response.body}');
    }
  }

  Future<void> _syncOfflineVisits() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) return;
    final offlineVisits = _visitBox.values.where((visit) => !visit.isSynced).toList();
    for (final visit in offlineVisits) {
      await _syncVisit(visit);
    }
  }

  Future<Map<String, int>> getVisitStats() async {
    final visits = await getVisits();
    return {
      'total': visits.length,
      'completed': visits.where((v) => v.status == 'Completed').length,
      'pending': visits.where((v) => v.status == 'Pending').length,
      'cancelled': visits.where((v) => v.status == 'Cancelled').length,
    };
  }
}
