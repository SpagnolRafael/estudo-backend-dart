import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../infra/security/security_service.dart';
import 'api.dart';

class Login extends Api {
  final SecurityService securityService;
  Login(this.securityService);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    router.post('/login', (Request request) async {
      var token = await securityService.generateJWT('1');
      var result = await securityService.validateJWT(token);
      return Response.ok(token);
    });

    return createHandler(router: router, middlewares: middlewares);
  }
}
