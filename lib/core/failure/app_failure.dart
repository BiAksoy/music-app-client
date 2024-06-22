class AppFailure {
  final String message;

  AppFailure([this.message = 'An unexpected error occurred.']);

  @override
  String toString() => message;
}
