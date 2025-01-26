import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:linlin_kit/core/services/api_service.dart';
import 'package:linlin_kit/models/login_validation_error.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginInProgress());
      try {
        final response = await ApiService().login(
          email: event.email,
          password: event.password,
        );
      } catch (e) {
        if (e is DioException) {
          final loginValidationError =
              LoginValidationError.fromJson(e.response?.data);
          emit(LoginFailure(
              error: loginValidationError.message ?? 'Unknown error'));
        } else {
          emit(LoginFailure(error: 'Something went wrong'));
        }
      }
    });
  }
}
