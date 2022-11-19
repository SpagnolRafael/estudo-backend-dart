import 'package:shelf/shelf.dart';
import '../../utils/custom_env.dart';
import 'security_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class SecurityServiceImp implements SecurityService<JWT> {
  @override
  Future<String> generateJWT(String userId) async {
    var jwt = JWT({
      'iat': DateTime.now().millisecondsSinceEpoch,
      'userID': userId,
      'roles': ['admin', 'user']
    });

    String key = await CustomEnv.get(key: 'jwt_key');

    return jwt.sign(SecretKey(key));
  }

  @override
  Future<JWT?> validateJWT(String token) async {
    String key = await CustomEnv.get(key: 'jwt_key');
    try {
      return JWT.verify(token, SecretKey(key));
    } on JWTInvalidError {
      return null;
    } on JWTExpiredError {
      return null;
    } on JWTNotActiveError {
      return null;
    } on JWTUndefinedError {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Middleware get authorization {
    //mesma coisa que o metodo create Middleware (utilizado no verifyJwt)
    return (Handler handler) {
      return (Request request) async {
        String? authorizationHeader = request.headers['Authorization'];
        JWT? jwt;
        if (authorizationHeader != null) {
          if (authorizationHeader.startsWith('Bearer ')) {
            String token = authorizationHeader.substring(7);
            jwt = await validateJWT(token);
          }
        }
        var req = request.change(context: {
          'jwt': jwt,
        });
        return handler(req);
      };
    };
  }

  @override
  // TODO: implement verifyJwt
  Middleware get verifyJwt => createMiddleware(
        requestHandler: (request) {
          if (request.context['jwt'] == null) {
            return Response.forbidden('Unauth -> Not Authorized');
          }
          return null;
        },
      );
}
