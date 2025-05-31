import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Customer extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final DateTime createdAt;

  const Customer({required this.id, required this.name, required this.createdAt});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as int,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, name, createdAt];
}

@HiveType(typeId: 1)
class Activity extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final DateTime createdAt;

  Activity({required this.id, required this.description, required this.createdAt});

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as int,
        description: json['description'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, description, createdAt];
}

@HiveType(typeId: 2)
class Visit extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int customerId;
  @HiveField(2)
  final DateTime visitDate;
  @HiveField(3)
  final String status;
  @HiveField(4)
  final String location;
  @HiveField(5)
  final String notes;
  @HiveField(6)
  final List<int> activitiesDone;
  @HiveField(7)
  final DateTime createdAt;
  @HiveField(8)
  final bool isSynced;

  Visit({
    required this.id,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
    required this.createdAt,
    this.isSynced = false,
  });

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
        id: json['id'] as int,
        customerId: json['customer_id'] as int,
        visitDate: DateTime.parse(json['visit_date'] as String),
        status: json['status'] as String,
        location: json['location'] as String,
        notes: json['notes'] as String,
        activitiesDone: (json['activities_done'] as List<dynamic>).cast<String>().map(int.parse).toList(),
        createdAt: DateTime.parse(json['created_at'] as String),
        isSynced: true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'visit_date': visitDate.toIso8601String(),
        'status': status,
        'location': location,
        'notes': notes,
        'activities_done': activitiesDone.map((e) => e.toString()).toList(),
        'created_at': createdAt.toIso8601String(),
      };

  Visit copyWith({
    int? id,
    int? customerId,
    DateTime? visitDate,
    String? status,
    String? location,
    String? notes,
    List<int>? activitiesDone,
    DateTime? createdAt,
    bool? isSynced,
  }) {
    return Visit(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      visitDate: visitDate ?? this.visitDate,
      status: status ?? this.status,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      activitiesDone: activitiesDone ?? this.activitiesDone,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  List<Object?> get props => [id, customerId, visitDate, status, location, notes, activitiesDone, createdAt, isSynced];
}
