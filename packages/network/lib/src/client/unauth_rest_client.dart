import 'package:network/src/client/rest_client.dart';
import 'package:network/src/error/failure_mapper.dart';

/// REST client for unauthenticated endpoints (login, registration, etc.).
class UnAuthRestClient extends RestClient {
  UnAuthRestClient(super.dio) : super(errorHandler: NetworkErrorHandlerImpl());
}
