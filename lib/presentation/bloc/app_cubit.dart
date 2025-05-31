import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview/data/models/models.dart';

import '../../data/repository/visit_repository.dart';

enum AppStatus {
  initial,
  loadingCustomers,
  loadingActivities,
  loadingVisits,
  loadingStats,
  success,
  error,
}

class AppCubitState extends Equatable {
  final AppStatus status;
  final List<Customer>? customers;
  final List<Activity>? activities;
  final List<Visit>? visits;
  final Map<String, int>? stats;
  final String? errorMessage;

  const AppCubitState({
    required this.status,
    this.customers,
    this.activities,
    this.visits,
    this.stats,
    this.errorMessage,
  });

  factory AppCubitState.initial() => const AppCubitState(status: AppStatus.initial);

  AppCubitState copyWith({
    AppStatus? status,
    List<Customer>? customers,
    List<Activity>? activities,
    List<Visit>? visits,
    Map<String, int>? stats,
    String? errorMessage,
  }) {
    return AppCubitState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      activities: activities ?? this.activities,
      visits: visits ?? this.visits,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, customers, activities, visits, stats, errorMessage];
}

class AppCubit extends Cubit<AppCubitState> {
  final VisitRepository _repository;

  AppCubit(this._repository) : super(AppCubitState.initial()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      loadCustomers(),
      loadActivities(),
      loadVisits(),
      loadStats(),
    ]);
  }

  Future<void> loadCustomers() async {
    emit(state.copyWith(status: AppStatus.loadingCustomers));
    try {
      final customers = await _repository.getCustomers();
      emit(state.copyWith(status: AppStatus.success, customers: customers, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> loadActivities() async {
    emit(state.copyWith(status: AppStatus.loadingActivities));
    try {
      final activities = await _repository.getActivities();
      emit(state.copyWith(status: AppStatus.success, activities: activities, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> loadVisits() async {
    emit(state.copyWith(status: AppStatus.loadingVisits));
    try {
      final visits = await _repository.getVisits();
      emit(state.copyWith(status: AppStatus.success, visits: visits, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> loadStats() async {
    emit(state.copyWith(status: AppStatus.loadingStats));
    try {
      final stats = await _repository.getVisitStats();
      emit(state.copyWith(status: AppStatus.success, stats: stats, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> addVisit(Visit visit) async {
    try {
      await _repository.addVisit(visit);
      await loadVisits();
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, errorMessage: 'Failed to add visit: $e'));
    }
  }
}
