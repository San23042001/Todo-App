abstract class ApiService {
  Future<dynamic> get(String url, {Map<String, String>? headers});
  Future<dynamic> post(String url,
      {Map<String, String>? headers, dynamic body});
}
