import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../bloc/app_cubit.dart';

class VisitsListScreen extends StatefulWidget {
  const VisitsListScreen({super.key});

  @override
  State<VisitsListScreen> createState() => _VisitsListScreenState();
}

class _VisitsListScreenState extends State<VisitsListScreen> {
  String _searchQuery = '';
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Visits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.go('/statistics'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by customer or location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _statusFilter,
              items: ['All', 'Completed', 'Pending', 'Cancelled'].map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
              onChanged: (value) => setState(() => _statusFilter = value!),
              isExpanded: true,
            ),
          ),
          Expanded(
            child: BlocBuilder<AppCubit, AppCubitState>(
              builder: (context, state) {
                if (state.status == AppStatus.loadingVisits) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == AppStatus.error && state.errorMessage != null) {
                  return Center(child: Text(state.errorMessage!));
                }
                print("state.visitsstate.visits ${state.visits}");

                final visits = state.visits?.where((visit) {
                      final matchesSearch = _searchQuery.isEmpty ||
                          state.customers!.firstWhere((c) => c.id == visit.customerId).name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          visit.location.toLowerCase().contains(_searchQuery.toLowerCase());
                      final matchesStatus = _statusFilter == 'All' || visit.status == _statusFilter;
                      return matchesSearch && matchesStatus;
                    }).toList() ??
                    [];

                return ListView.builder(
                  itemCount: visits.length,
                  itemBuilder: (context, index) {
                    final visit = visits[index];
                    final customer = state.customers?.firstWhere((c) => c.id == visit.customerId);
                    return ListTile(
                      title: Text(customer?.name ?? 'Unknown'),
                      subtitle: Text('${visit.location} - ${DateFormat.yMd().format(visit.visitDate)}'),
                      trailing: Text(visit.status),
                      onTap: () => context.go('/visit/${visit.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-visit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
