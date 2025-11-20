part of 'theme_bloc.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  Map<String, dynamic> toMap() {
    return {'themeMode': themeMode.index};
  }

  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(themeMode: ThemeMode.values[map['themeMode'] as int]);
  }
}
