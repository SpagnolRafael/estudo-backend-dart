import '../../apis/blog_api.dart';
import '../../apis/login_api.dart';
import '../../services/news_service.dart';
import '../../services/service.dart';
import '../security/secure_service_imp.dart';
import '../security/security_service.dart';
import 'dependency_injection.dart';

class Injects {
  static DependencyInjection initialize() {
    var di = DependencyInjection();

    di.register<SecurityService>(() => SecurityServiceImp(), isSingleton: true);
    di.register<Service>(() => NewsService(), isSingleton: true);
    di.register<Blog>(() => Blog(di.get()), isSingleton: true);
    //NAO USAMOS O DI.GET PQ CRIAMOS O CALLABLE
    di.register<Login>(() => Login(di.get()), isSingleton: true);

    return di;
  }
}
