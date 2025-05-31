Visits Tracker

Visits Tracker is a Flutter app for a Route-to-Market Sales Force Automation system. Sales reps can log customer visits, view lists, track activities, and see statistics, with offline support using Hive and integration with a Supabase REST API.

Implementation Overview: The app allows adding visits with customer details, location, date, notes, and activities. Visits are listed with search by customer or location and status filters. Activities are linked to predefined types. Statistics show counts of total, completed, pending, and cancelled visits. Offline visits are saved locally and synced when online. The app uses Cubit for state management, a repository pattern for data, and GoRouter for navigation.

Screenshots: Placeholder for Visits List showing a scrollable list with customer names, locations, statuses, search bar, and filter. Placeholder for Add Visit showing a form with customer dropdown, location and notes fields, date picker, and activity checkboxes. Placeholder for Visit Details showing customer, date, status, location, notes, and activities. Placeholder for Statistics showing counts of visits by status.

Architectural Choices: Cubit from flutter_bloc was chosen for simple state management, avoiding complex Bloc events for a small app. A single AppCubitState manages customers, activities, visits, and stats for efficiency, using Equatable for UI updates. The repository pattern abstracts Supabase API and Hive storage, enabling easy data source changes. GoRouter provides type-safe navigation for scalability. Hive was selected over Isar for lightweight offline storage and simpler setup, avoiding schema errors. Material Design 3 ensures a modern, consistent UI.

Setup Instructions: Clone the repository with git clone git@github.com:kelvinwm/flutter-app-00.git and cd visits_tracker. Install dependencies with flutter pub get and flutter pub upgrade. Generate Hive models with flutter pub run build_runner build --delete-conflicting-outputs. Run the app with flutter run. The Supabase API key is hardcoded in VisitRepository so use environment variables in production.

Offline Support and Testing: Offline support saves visits to Hive with isSynced set to false, syncing when online using connectivity_plus. Editing or deleting visits offline is not supported. Unit tests for VisitRepository are in test/repository/visit_repository_test.dart, using mockito for HTTP mocks; run with flutter test. No CI is implemented, but tests support future pipelines. Future work includes widget and Cubit tests.

Assumptions, Trade-offs, Limitations: Assumes a fixed API format and single-user usage; multi-user support needs authentication. All visits start as Pending. Trade-offs include a single Cubit for simplicity, which may not scale for larger apps, and Hive over Isar for ease but weaker querying. Limitations include no visit editing or deleting, basic statistics with counts only, and offline support limited to visit creation.

Key Fixes: Updated analyzer to 7.4.5 for Dart 3.6.0 compatibility. Fixed models.hive.dart generation with correct annotations and build_runner. Excluded id from Supabase POST requests to respect GENERATED ALWAYS identity column. Added temporary id for offline visits, updated on sync.

For issues or contributions see the project repository.