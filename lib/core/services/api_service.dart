import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../network/dio_client.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService() : _dioClient = DioClient();

  Future<Response> getProducts({
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiConfig.products,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      // Handle Dio-specific exceptions if needed
      rethrow;
    } catch (e) {
      // Handle other exceptions
      throw Exception('Unknown error occurred');
    }
  }

  //make login request
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioException {
      rethrow;
    } catch (e) {
      // Handle other exceptions
      throw Exception('Unknown error occurred');
    }
  }
}
