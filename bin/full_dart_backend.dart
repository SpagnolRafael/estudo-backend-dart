import 'package:shelf/shelf.dart';
import 'apis/blog_api.dart';
import 'apis/login_api.dart';
import 'infra/custom_server.dart';
import 'infra/dependency_injection/injects.dart';
import 'infra/middleware_interception.dart';
import 'infra/security/security_service.dart';
import 'utils/custom_env.dart';

//COMECA NA AULA 08 DO YOUTUBE PLAYLIST CURSO BACKEND COM DEIVID WILLYAN
void main(List<String> arguments) async {
  //SE CRIAR O CUSTOM ENV ELE MUDA O ENDERECO AO INVES DE LOCALHOST VAI PARA O OUTRO 127...
  CustomEnv.fromFile('.env-dev');

  final di = Injects.initialize();

  //REGISTER DEPENDENCY INJECTION

  //RECOVER DEPENDENCY
  var securityService = di.get<SecurityService>();

  CustomServer server = CustomServer();
  Cascade cascade = Cascade();

  var cascadeHandler = cascade
      .add(di.get<Login>().getHandler())
      .add(di.get<Blog>().getHandler(isSecurity: true))
      .handler;

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(MiddlewareInterception().middleware)
      .addHandler(cascadeHandler);

  await server.initialize(
    handler: handler,
    address: await CustomEnv.get<String>(key: 'server_address'),
    port: await CustomEnv.get<int>(key: 'server_port'),
  );
}
