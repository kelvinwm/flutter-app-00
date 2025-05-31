import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_cubit.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visit Statistics')),
      body: BlocBuilder<AppCubit, AppCubitState>(
        builder: (context, state) {
          if (state.status == AppStatus.loadingStats) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AppStatus.error && state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          final stats = state.stats ?? {'total': 0, 'completed': 0, 'pending': 0, 'cancelled': 0};
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Visits: ${stats['total']}'),
                Text('Completed: ${stats['completed']}'),
                Text('Pending: ${stats['pending']}'),
                Text('Cancelled: ${stats['cancelled']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
