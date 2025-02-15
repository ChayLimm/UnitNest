import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the StateNotifier that will manage the state
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0); // Initial state is 0
// Define the provider for the CounterNotifier
}


final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

// Define the StateNotifier that will handle the error message
class ErrorNotifier extends StateNotifier<String> {
  ErrorNotifier() : super('');

  // Method to set an error message
  void setError(String errorMessage) {
    state = errorMessage;
  }

  // Method to clear the error message
  void clearError() {
    state = '';
  }
}

// Define the provider for the ErrorNotifier
final errorProvider = StateNotifierProvider<ErrorNotifier, String>((ref) {
  return ErrorNotifier();
});
