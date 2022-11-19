import '../models/news_model.dart';

abstract class Service {
  Future fetchAll() async {}
  Future delete(String id, Type value) async {}
  Future update(String id, Type value) async {}
  Future create(News value) async {}
  Future findOne(String id) async {}
}
