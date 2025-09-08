import 'package:dio/dio.dart';
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

void setupDio() {
  print("DIO INTERCEPTOR");
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("token");
      print("accessToken: ${accessToken}");
      if (accessToken != null) {
        options.headers["Authorization"] = "Bearer $accessToken";
      }

      return handler.next(options);
    },
    onError: (DioError error, handler) async {
      if (error.response?.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        final refreshToken = prefs.getString("refreshToken");

        if (refreshToken != null) {
          try {
            final response =
                await dio.post("$baseUrl/api/refresh-token", data: {
              "refreshToken": refreshToken,
            });

            final newAccessToken = response.data["accessToken"];
            final newRefreshToken = response.data["refreshToken"];

            await prefs.setString("accessToken", newAccessToken);
            await prefs.setString("refreshToken", newRefreshToken);

            // Retry the failed request
            final cloneReq = error.requestOptions;
            cloneReq.headers["Authorization"] = "Bearer $newAccessToken";

            final retryResponse = await dio.fetch(cloneReq);
            return handler.resolve(retryResponse);
          } catch (refreshErr) {
            // Refresh failed: clear tokens and reject properly
            await prefs.remove("accessToken");
            await prefs.remove("refreshToken");

            if (refreshErr is DioException) {
              return handler.reject(refreshErr);
            } else {
              return handler.reject(DioException(
                requestOptions: error.requestOptions,
                error: refreshErr,
                type: DioExceptionType.unknown,
              ));
            }
          }
        }
      }

      return handler.next(error);
    },
  ));
}
