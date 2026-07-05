class AppError implements Exception {
  final String errorMessage;
  final Object? cause;

  const AppError({required this.errorMessage, this.cause});

  @override
  String toString() {
    return 'AppExeption(message: $errorMessage)';
  }
}

class AppSuccess implements Exception {
  final String successMessage;
  final Object? cause;

  const AppSuccess({required this.successMessage, this.cause});

  @override
  String toString() {
    return 'AppExeption(message: $successMessage)';
  }
}
