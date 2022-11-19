import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../infra/security/security_service.dart';

class Login {
  final SecurityService securityService;
  Login(this.securityService);

  //HANDLER IS FROM SHELF PACKAGE
  Handler get handler {
    //ROUTER IS FROM SHELF_ROUTER PACKAGE
    Router router = Router();

    router.post('/login', (Request request) async {
      var token = await securityService.generateJWT('1');
      var result = await securityService.validateJWT(token);
      return Response.ok(token);
    });

    return router;
  }
}
