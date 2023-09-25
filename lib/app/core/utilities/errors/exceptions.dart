class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  @override
  String toString() => message;
}

class ConnectionException implements Exception {
  final String message;
  ConnectionException(this.message);
  @override
  String toString() => message;
}
