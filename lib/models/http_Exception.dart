class HttpException implements Exception {
  final String errorMsg;

  HttpException(this.errorMsg);

  @override
  String toString() {
    // TODO: implement toString
    return errorMsg;
  }
}
