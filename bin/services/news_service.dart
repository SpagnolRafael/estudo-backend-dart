import '../models/news_model.dart';
import 'service.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class NewsService implements Service {
  // ignore: prefer_final_fields
  List<News> _fakeDB = [];

  @override
  Future<bool> delete(String id, Type value) async {
    _fakeDB.removeWhere((element) => element.id == id);
    return true;
  }

  @override
  Future<List<News>> fetchAll() async {
    return _fakeDB;
  }

  @override
  Future update(String id, Type value) async {}

  @override
  Future<bool> create(News value) async {
    //se ele não localizar essa comparação do first where, ele cai no orElse e devolve o objeto pra gente add na lista sem repetir
    final news = _fakeDB.firstWhereOrNull(
      (element) => element.id == value.id,
    );
    if (news == null) {
      _fakeDB.add(value);
    } else {
      var index = _fakeDB.indexOf(news);
      _fakeDB[index] = value;
    }
    return true;
  }

  @override
  Future<News> findOne(String id) async {
    return _fakeDB.firstWhere((element) => element.id == id);
  }
}
