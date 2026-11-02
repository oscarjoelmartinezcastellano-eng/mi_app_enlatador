import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceHTTP {
  final String baseUrl;

  ServiceHTTP({this.baseUrl = 'http://192.168.2.240:2000'});
  //ServiceHTTP({this.baseUrl = 'http://192.168.2.174:2000'});

  Future<http.Response> enviarDatos(
    Map<String, dynamic> datos, {
    required String tipo,
  }) async {
    final url = Uri.parse('$baseUrl/$tipo');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datos),
      );

      print('✅ Enviado a $url');
      print('📦 Payload: $datos');
      print('📬 Código de estado: ${response.statusCode}');
      print('📨 Respuesta: ${response.body}');

      return response;
    } catch (e) {
      print('❌ Error al enviar los datos: $e');
      rethrow;
    }
  }
}