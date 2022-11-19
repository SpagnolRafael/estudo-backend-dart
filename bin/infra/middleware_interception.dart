import 'package:shelf/shelf.dart';

class MiddlewareInterception {
  Middleware get middleware {
    return createMiddleware(
      responseHandler: (Response response) =>
          response.change(headers: {'content-type': 'application/json'}),
    );
  }
}
