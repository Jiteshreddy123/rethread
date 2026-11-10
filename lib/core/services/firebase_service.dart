import 'dart:developer' as developer;

/// FirebaseService encapsulates backend connectivity guidance for Cloud Firestore,
/// Authentication, and Firebase Storage.
/// 
/// To connect your live Firebase console project to this app:
/// 1. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
/// 2. Run: `flutterfire configure` (select your Firebase project)
/// 3. In `lib/main.dart`, uncomment:
///    `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);`
class FirebaseService {
  // Prevent instantiation
  const FirebaseService._();

  static const String usersCollection = 'users';
  static const String itemsCollection = 'items';
  static const String requestsCollection = 'requests';
  static const String notificationsCollection = 'notifications';
  static const String repairCentresCollection = 'repair_centres';
  static const String recyclingCentresCollection = 'recycling_centres';

  static void logEvent(String eventName, [Map<String, dynamic>? parameters]) {
    developer.log('Firebase Analytics Event: $eventName, params: $parameters');
  }
}
