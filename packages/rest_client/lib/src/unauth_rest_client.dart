import 'package:rest_client/src/network.dart';

class UnAuthRestClient extends RestClient {
  UnAuthRestClient(super.client)
      : super(errorHandler: NetworkErrorHandlerImpl());
}
