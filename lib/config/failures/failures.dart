class Failure {
  final String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({super.message = "Internal Server Failure."});
}

class CacheFailure extends Failure {
  CacheFailure({super.message = "Uh-oh! Something went wrong. Please retry."});
}

class NetworkFailure extends Failure {
  NetworkFailure({super.message = "Network connection error."});
}

class TimeoutFailure extends Failure {
  TimeoutFailure({super.message = "INTERNET IS SLOW. NEED FASTER CONNECTION."});
}

class ConnectionFailure extends Failure {
  ConnectionFailure({super.message = "APP EXPERIENCING INTERNET OUTAGE."});
}

class GeneralFailure extends Failure {
  GeneralFailure({super.message = "Something went wrong."});
}
