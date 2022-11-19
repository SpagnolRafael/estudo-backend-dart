import 'package:shelf/shelf.dart';

import 'apis/blog_api.dart';
import 'apis/login_api.dart';
import 'infra/custom_server.dart';
import 'infra/middleware_interception.dart';
import 'infra/security/secure_service_imp.dart';
import 'services/news_service.dart';
import 'utils/custom_env.dart';

//COMECA NA AULA 08 DO YOUTUBE PLAYLIST CURSO BACKEND COM DEIVID WILLYAN
void main(List<String> arguments) async {
  //SE CRIAR O CUSTOM ENV ELE MUDA O ENDERECO AO INVES DE LOCALHOST VAI PARA O OUTRO 127...
  CustomEnv.fromFile('.env-dev');

  CustomServer server = CustomServer();
  Cascade cascade = Cascade();

  //API'S
  Login login = Login(SecurityServiceImp());
  Blog blog = Blog(NewsService());

  var cascadeHandler = cascade.add(login.handler).add(blog.handler).handler;
  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(MiddlewareInterception().middleware)
      .addMiddleware(SecurityServiceImp().authorization)
      .addMiddleware(SecurityServiceImp().verifyJwt)
      .addHandler(cascadeHandler);

  await server.initialize(
    handler: handler,
    address: await CustomEnv.get<String>(key: 'server_address'),
    port: await CustomEnv.get<int>(key: 'server_port'),
  );
}
