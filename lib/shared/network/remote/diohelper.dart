import 'package:dio/dio.dart';
import 'package:social_app/shared/components/constants.dart';

class DioHelper {
  static Dio? dio;

  static Future<void> init() async {
    dio = Dio(BaseOptions(
        baseUrl: ' https://fcm.googleapis.com/fcm/send',
        receiveDataWhenStatusError: true));
  }

  static Future<Response> getData(
      {required String url, required Map<String, dynamic> query}) async {
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    dio!.options.headers = {
      'Authorization': 'key=$API_FCM_KEY',
      'Content-Type': 'application/json',
    };

    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
