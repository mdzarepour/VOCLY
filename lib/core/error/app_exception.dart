class AppError implements Exception {
  final String errorMessage;
  final Object? cause;

  const AppError({required this.errorMessage, this.cause});

  @override
  String toString() {
    return 'AppExeption(message: $errorMessage)';
  }
}

class AppSuccess<T> implements Exception {
  final String? successMessage;
  final T? successData;
  final Object? cause;

  const AppSuccess({this.successMessage, this.successData, this.cause});

  @override
  String toString() {
    return 'AppExeption(message: $successMessage)';
  }
}
