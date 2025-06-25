import 'dart:convert';
import 'package:dio/dio.dart';

class EmailApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://payin-mailer.xell.workers.dev', // ganti URL hasil `wrangler deploy`
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> sendInvoice({
    required String to,
    required String subject,
    required String html,
    List<int>? pdfBytes,
  }) async {
    final url = '${_dio.options.baseUrl}/';

  try {
    print('📡 POST $url');
    await _dio.post('', data: {  'to': to,
      'subject': subject,
      'html': html,
      if (pdfBytes != null) 'pdf': base64Encode(pdfBytes),});
    print('✅ 202 Accepted');
  } on DioException catch (e) {
    print('❌ DioException:');
    print('  type      : ${e.type}');          // connectionTimeout, badCertificate, dll.
    print('  message   : ${e.message}');
    print('  response  : ${e.response}');
    rethrow;
  }
  }
}