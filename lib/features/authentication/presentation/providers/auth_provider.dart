import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_model.dart';

/// Notifier managing current authentication and user profile state.
class AuthNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    // Default demo user so developer/examiner can explore all features immediately
    return UserModel(
      uid: 'user_alex_101',
      displayName: 'Alex Morgan',
      email: 'alex.morgan@rethread.community',
      photoUrl: null,
      city: 'Bengaluru',
      area: 'Indiranagar',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    );
  }

  /// Sign In with Email & Password
  Future<bool> signIn(String email, String password) async {
    // Simulating authentication delay
    await Future.delayed(const Duration(milliseconds: 600));

    state = UserModel(
      uid: 'user_alex_101',
      displayName: email.split('@').first.toUpperCase(),
      email: email,
      photoUrl: null,
      city: 'Bengaluru',
      area: 'Indiranagar',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    );
    return true;
  }

  /// Sign Up with Email, Password, Name, City, and Area
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String city,
    required String area,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    state = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      displayName: name,
      email: email,
      photoUrl: null,
      city: city,
      area: area,
      createdAt: DateTime.now(),
    );
    return true;
  }

  /// Update Profile Details
  void updateProfile({
    required String displayName,
    required String city,
    required String area,
  }) {
    if (state != null) {
      state = state!.copyWith(
        displayName: displayName,
        city: city,
        area: area,
      );
    }
  }

  /// Sign Out
  void signOut() {
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

/// Convenience provider checking if user is logged in
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) != null;
});
