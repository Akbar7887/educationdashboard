import 'api.dart';

class Repository {
  final Api _api = Api();

  Future<bool> login(String user, String passwor) =>
      _api.login(user, passwor);

  Future<List<dynamic>> getall(String url) => _api.getall(url);



  // Future<List<ImageCatalog>> getimagecatalog(String id) => api.getImageCatalog(id);
}
