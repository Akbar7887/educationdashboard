import 'api.dart';

class Repository {
  final Api _api = Api();

  Future<bool> login(String user, String passwor) =>
      _api.login(user, passwor);

  Future<List<dynamic>> getall(String url) => _api.getall(url);

  Future<dynamic> saveId(String url, Object object,String nameid, String id) => _api.saveId(url, object, nameid, id);

  Future<dynamic> remove(String url,String id) => _api.remove(url, id);


  Future<dynamic> save(String url, Object object) => _api.save(url, object);

// Future<List<ImageCatalog>> getimagecatalog(String id) => api.getImageCatalog(id);
}
