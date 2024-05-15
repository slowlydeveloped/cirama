import '../models/config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  String? baseUrl;
  String? apiKey;

  HTTPService() {
    AppConfig config = getIt.get<AppConfig>();
    baseUrl = config.BASE_API_URL;
    apiKey = config.API_KEY;
  }

  Future<Response> get(String path,
      {required Map<String, dynamic> query}) async {
    try {
      String url = '$baseUrl $path';
      Map<String, dynamic> query = {
        'apiKey': apiKey,
        'language': 'en-US',
      };
      query.addAll(query);
          return await dio.get(url, queryParameters: query);
    } on DioException catch (e) {
      print("Unable to get request");
      print("Dio error: $e");
      return Future.error("Unable to perform GET request: $e");
    }
  }
}
