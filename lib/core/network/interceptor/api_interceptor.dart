import 'package:dio/dio.dart';
import '../exeption/api_exeption.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    // final token = getToken(); // Implement your token retrieval logic
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle successful responses
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DeadlineExceededException(err.requestOptions);
        break;
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            err = BadRequestException(err.requestOptions);
            break;
          case 401:
            err = UnauthorizedException(err.requestOptions);
            break;
          case 404:
            err = NotFoundException(err.requestOptions);
            break;
          case 409:
            err = ConflictException(err.requestOptions);
            break;
          case 500:
            err = InternalServerErrorException(err.requestOptions);
            break;
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        err = NoInternetConnectionException(err.requestOptions);
        break;
      default:
        break;
    }
    return handler.next(err);
  }
}
