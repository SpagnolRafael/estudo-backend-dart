import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/news_model.dart';
import '../services/service.dart';
import 'api.dart';

class Blog extends Api {
  final Service _service;
  Blog(this._service);

  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    router.get('/blog/news', (Request request) async {
      String? id = request.url.queryParameters['id'];
      if (id != null) _service.findOne(id);
      List<News> news = await _service.fetchAll();
      List<Map> mapNews = news.map((e) => e.toJson()).toList();
      return Response.ok(jsonEncode(mapNews));
    });

    router.post('/blog/news', (Request request) async {
      var body = await request.readAsString();
      _service.create(News.fromJsom(jsonDecode(body)));
      return Response(201);
    });

    router.put('/blog/news', (Request request) {
      String? id = request.url.queryParameters['id'];
      // _service.update();
      return Response.ok('choveu hoje $id');
    });

    router.delete('/blog/news', (Request request) {
      String? id = request.url.queryParameters['id'];
      // _service.delete();
      return Response.ok('Deletado $id');
    });

    return createHandler(
        router: router, middlewares: middlewares, isSecurity: isSecurity);
  }
}
