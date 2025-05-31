import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview/data/models/models.dart';
import 'package:interview/data/repository/visit_repository.dart';

import 'presentation/bloc/app_cubit.dart';
import 'presentation/screens/add_visit_screen.dart';
import 'presentation/screens/statistics_screen.dart';
import 'presentation/screens/visit_details_screen.dart';
import 'presentation/screens/visits_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(VisitAdapter());
  final visitRepository = VisitRepository();
  await visitRepository.init();
  runApp(MyApp(visitRepository: visitRepository));
}

class MyApp extends StatelessWidget {
  final VisitRepository visitRepository;

  const MyApp({required this.visitRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(visitRepository),
      child: MaterialApp.router(
        title: 'Visits Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const VisitsListScreen(),
            ),
            GoRoute(
              path: '/add-visit',
              builder: (context, state) => const AddVisitScreen(),
            ),
            GoRoute(
              path: '/visit/:id',
              builder: (context, state) => VisitDetailsScreen(
                visitId: int.parse(state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              path: '/statistics',
              builder: (context, state) => const StatisticsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
