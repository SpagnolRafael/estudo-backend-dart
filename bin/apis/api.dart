import 'package:shelf/shelf.dart';

import '../infra/dependency_injection/dependency_injection.dart';
import '../infra/security/security_service.dart';

abstract class Api {
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false});

  Handler createHandler(
      {required Handler router,
      List<Middleware>? middlewares,
      bool isSecurity = false}) {
    middlewares ??= [];

    if (isSecurity) {
      var _securityService = DependencyInjection().get<SecurityService>();
      middlewares.addAll([
        _securityService.authorization,
        _securityService.verifyJwt,
      ]);
    }

    var pipelane = Pipeline();
    middlewares
        // ignore: avoid_function_literals_in_foreach_calls
        .forEach((middleware) => pipelane = pipelane.addMiddleware(middleware));
    return pipelane.addHandler(router);
  }
}
