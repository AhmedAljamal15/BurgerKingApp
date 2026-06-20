import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../data/auth_repo.dart';
import '../data/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepo _authRepo = AuthRepo();

  // ─── Getters ────────────────────────────────────────────────────────────────

  /// Returns the current user if state is a success state, otherwise null.
  UserModel? get currentUser {
    final s = state;
    if (s is AuthSuccess) return s.user;
    if (s is AuthProfileUpdating) return s.user;
    if (s is AuthProfileUpdateSuccess) return s.user;
    return null;
  }

  bool get isGuest => state is AuthGuest;
  bool get isLoggedIn => state is AuthSuccess ||
      state is AuthProfileUpdating ||
      state is AuthProfileUpdateSuccess;

  // ─── Auth Flow ──────────────────────────────────────────────────────────────

  /// Automatically login on app start (checks saved token).
  Future<void> autoLogin() async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.autoLogin();
      if (_authRepo.isGuest) {
        emit(AuthGuest());
      } else if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthLoggedOut());
    }
  }

  /// Login with email and password.
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.login(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Login failed: no user returned'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Signup with name, email and password.
  Future<void> signup(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.signup(name, email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Signup failed: no user returned'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Load the current user profile from the server.
  Future<void> getProfile() async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.getProfileData();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthGuest());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Update the current user's profile.
  Future<void> updateProfile({
    required String name,
    required String email,
    required String address,
    String? visa,
    String? imagePath,
  }) async {
    final current = currentUser;
    if (current != null) emit(AuthProfileUpdating(current));
    try {
      final user = await _authRepo.updateProfileData(
        name: name,
        email: email,
        address: address,
        visa: visa,
        imagePath: imagePath,
      );
      if (user != null) {
        emit(AuthProfileUpdateSuccess(user));
        // Refresh profile after update
        await getProfile();
      } else {
        emit(AuthError('Profile update failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Log out the current user.
  Future<void> logout() async {
    try {
      await _authRepo.logout();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Continue the app as a guest (no account).
  Future<void> continueAsGuest() async {
    await _authRepo.continueAsGuest();
    emit(AuthGuest());
  }

  // ─── Image Picking ───────────────────────────────────────────────────────────

  String? _selectedImagePath;
  String? get selectedImagePath => _selectedImagePath;

  /// Opens the image picker and stores the selected path.
  Future<String?> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      _selectedImagePath = pickedImage.path;
      return pickedImage.path;
    }
    return null;
  }

  void clearSelectedImage() {
    _selectedImagePath = null;
  }
}
