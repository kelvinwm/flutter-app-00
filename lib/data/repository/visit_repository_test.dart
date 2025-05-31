import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:interview/data/models/models.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'visit_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late VisitRepository repository;
  late MockHttpClient mockHttpClient;
  late MockConnectivity mockConnectivity;

  setUp(() async {
    Hive.init('test_hive');
    Hive.registerAdapter(CustomerAdapter());
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(VisitAdapter());
    mockHttpClient = MockHttpClient();
    mockConnectivity = MockConnectivity();
    repository = VisitRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  // test('getCustomers fetches and stores customers', () async {
  //   when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);
  //   when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(
  //         jsonEncode([
  //           {'id': 1, 'name': 'Acme Corporation', 'created_at': '2025-04-30T05:22:37.623162+00:00'},
  //         ]),
  //         200,
  //       ));
  //
  //   final customers = await repository.getCustomers();
  //   expect(customers.length, 1);
  //   expect(customers[0].name, 'Acme Corporation');
  // });
}
