import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/app_cubit.dart';

class VisitDetailsScreen extends StatelessWidget {
  final int visitId;

  const VisitDetailsScreen({required this.visitId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Details'),
      ),
      body: BlocBuilder<AppCubit, AppCubitState>(
        builder: (context, state) {
          final visit = state.visits?.firstWhere((v) => v.id == visitId);
          final customer = state.customers?.firstWhere((c) => c.id == visit?.customerId);
          final activities = state.activities?.where((a) => visit?.activitiesDone.contains(a.id) ?? false).toList();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: ${customer?.name ?? 'Unknown'}', style: const TextStyle(fontSize: 18)),
                Text('Date: ${visit != null ? DateFormat.yMd().format(visit.visitDate) : 'N/A'}'),
                Text('Status: ${visit?.status ?? 'N/A'}'),
                Text('Location: ${visit?.location ?? 'N/A'}'),
                Text('Notes: ${visit?.notes ?? 'None'}'),
                const SizedBox(height: 16),
                const Text('Activities Done:', style: TextStyle(fontWeight: FontWeight.bold)),
                if (activities != null && activities.isNotEmpty) ...activities.map((a) => Text('• ${a.description}')) else const Text('No activities'),
              ],
            ),
          );
        },
      ),
    );
  }
}
