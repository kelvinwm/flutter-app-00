import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/models/models.dart';
import '../bloc/app_cubit.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedCustomerId;
  String _location = '';
  String _notes = '';
  DateTime _visitDate = DateTime.now();
  final List<int> _selectedActivities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Visit')),
      body: BlocBuilder<AppCubit, AppCubitState>(
        builder: (context, state) {
          if (state.status == AppStatus.loadingCustomers || state.status == AppStatus.loadingActivities) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Customer'),
                  items: state.customers
                      ?.map((customer) => DropdownMenuItem(
                            value: customer.id,
                            child: Text(customer.name),
                          ))
                      .toList(),
                  value: _selectedCustomerId,
                  onChanged: (value) => setState(() => _selectedCustomerId = value),
                  validator: (value) => value == null ? 'Please select a customer' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Location'),
                  onChanged: (value) => _location = value,
                  validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                ),
                ListTile(
                  title: Text('Visit Date: ${DateFormat.yMd().format(_visitDate)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _visitDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => _visitDate = picked);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                  onChanged: (value) => _notes = value,
                ),
                const SizedBox(height: 16),
                const Text('Activities', style: TextStyle(fontWeight: FontWeight.bold)),
                ...state.activities?.map((activity) => CheckboxListTile(
                          title: Text(activity.description),
                          value: _selectedActivities.contains(activity.id),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedActivities.add(activity.id);
                              } else {
                                _selectedActivities.remove(activity.id);
                              }
                            });
                          },
                        )) ??
                    [],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final visit = Visit(
                        id: -1,
                        customerId: _selectedCustomerId!,
                        visitDate: _visitDate,
                        status: 'Pending',
                        location: _location,
                        notes: _notes,
                        activitiesDone: _selectedActivities,
                        createdAt: DateTime.now(),
                      );
                      context.read<AppCubit>().addVisit(visit).then((_) => context.go('/'));
                    }
                  },
                  child: const Text('Save Visit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
