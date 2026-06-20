part of 'auth_cubit.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Full login/signup/profile success
class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}

/// User chose to continue as guest
class AuthGuest extends AuthState {}

/// Auth action resulted in an error
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

/// User has logged out
class AuthLoggedOut extends AuthState {}

/// Profile update in progress
class AuthProfileUpdating extends AuthState {
  final UserModel user;
  AuthProfileUpdating(this.user);
}

/// Profile update completed
class AuthProfileUpdateSuccess extends AuthState {
  final UserModel user;
  AuthProfileUpdateSuccess(this.user);
}
