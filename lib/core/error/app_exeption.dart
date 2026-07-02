class AppExeption implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final Object? cause;
  final StackTrace? stackTrace;

  const AppExeption({
    required this.message,
    this.code,
    this.statusCode,
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppExeption(message: $message, code: $code)';
  }
}
