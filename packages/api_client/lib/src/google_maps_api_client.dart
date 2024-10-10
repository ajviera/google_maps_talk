import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

/// {@template api_request_options}
/// Provide optional fields to be passed for [GoogleMapsApiClient] requests.
/// {@endtemplate}
class ApiRequestOptions extends Equatable {
  /// {@macro api_request_options}
  const ApiRequestOptions({this.headers});

  /// Json content type header.
  static const json = ApiRequestOptions(
    headers: {'Content-Type': 'application/json'},
  );

  /// Map containing headers to be used on the request (e.g. Authorization).
  final Map<String, String>? headers;

  @override
  List<Object?> get props => [headers];

  /// Merges this with the received [options] returning a new instance
  ApiRequestOptions merge(ApiRequestOptions options) {
    final newHeaders = options.headers != null || headers != null
        ? <String, String>{
            ...headers ?? <String, String>{},
            ...options.headers ?? <String, String>{},
          }
        : null;

    return ApiRequestOptions(headers: newHeaders);
  }
}

/// {@template http_api_client}
/// A client that prepares an http client based on an api key.
/// {@endtemplate}
class GoogleMapsApiClient {
  /// {@macro http_api_client}
  GoogleMapsApiClient({
    required String apiUrl,
    required String apiKey,
    Client? httpClient,
  })  : assert(!apiUrl.endsWith(_separator), () {
          throw Exception('Error: api URL must not end with $_separator.');
        }),
        _apiUrl = apiUrl,
        _apiKey = apiKey,
        _httpClient = httpClient ?? Client();

  static const _separator = '/';

  /// The base url of the API
  final String _apiUrl;

  /// The API key used to access the http client
  // ignore: unused_field
  final String _apiKey;

  final Client _httpClient;

  ApiRequestOptions get _apiKeyHeader {
    return ApiRequestOptions(
      headers: {
        'X-Goog-Api-Key': _apiKey,
      },
    );
  }

  Uri _buildUri(String path) {
    assert(path.startsWith('/'), () {
      throw Exception('Error: path must start with $_separator.');
    });
    return Uri.parse('$_apiUrl$path');
  }

  Map<String, String>? _mapRequestOptions(ApiRequestOptions? options) {
    if (options != null) {
      return options.merge(_apiKeyHeader).headers;
    }
    return _apiKeyHeader.headers;
  }

  /// Makes a patch request to the given [path] and returns
  /// a future [Response]
  Future<Response> getGoogleRoutes(
    String path, {
    Object? body,
    ApiRequestOptions? options,
  }) async {
    try {
      final response = await _httpClient.post(
        _buildUri(path),
        body: body,
        headers: _mapRequestOptions(options),
      );
      return response;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
