import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'main.dart' show Catatan;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  // Bisa di-override saat build pakai --dart-define agar mudah menguji
  // skenario error jaringan (P5) tanpa mengubah kode.
  static const String _baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://besab-production.up.railway.app/api',
  );
  static const String _apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '8f38b5fbf0bc437285f2c62ed6e447eab56f78c8f95239a7',
  );
  static const _timeout = Duration(seconds: 10);

  Map<String, String> get _headers => {
    'X-API-Key': _apiKey,
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // GET /catatan
  Future<List<Catatan>> getAll() async {
    final res = await _send(() => http.get(
      Uri.parse('$_baseUrl/catatan'),
      headers: _headers,
    ));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (body['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Catatan.fromJson).toList();
  }

  // GET /catatan/{id}
  Future<Catatan> getById(int id) async {
    final res = await _send(() => http.get(
      Uri.parse('$_baseUrl/catatan/$id'),
      headers: _headers,
    ));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return Catatan.fromJson(body['data'] as Map<String, dynamic>);
  }

  // POST /catatan
  Future<Catatan> insert(Catatan c) async {
    final res = await _send(() => http.post(
      Uri.parse('$_baseUrl/catatan'),
      headers: _headers,
      body: jsonEncode(c.toJson()),
    ));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return Catatan.fromJson(body['data'] as Map<String, dynamic>);
  }

  // PUT /catatan/{id}
  Future<Catatan> update(Catatan c) async {
    assert(c.id != null);
    final res = await _send(() => http.put(
      Uri.parse('$_baseUrl/catatan/${c.id}'),
      headers: _headers,
      body: jsonEncode(c.toJson()),
    ));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return Catatan.fromJson(body['data'] as Map<String, dynamic>);
  }

  // DELETE /catatan/{id}
  Future<void> delete(int id) async {
    await _send(() => http.delete(
      Uri.parse('$_baseUrl/catatan/$id'),
      headers: _headers,
    ));
  }

  // ── Helper: kirim request + tangani 3 kelas error ──
  Future<http.Response> _send(Future<http.Response> Function() req) async {
    try {
      final res = await req().timeout(_timeout);
      if (res.statusCode >= 200 && res.statusCode < 300) return res;
      throw ApiException(res.statusCode, _httpMessage(res));
    } on SocketException catch (e) {
      if (e.message.contains('Failed host lookup')) {
        // "Failed host lookup" bisa berarti dua hal:
        //  - tidak ada internet sama sekali (Wi-Fi/data mati), atau
        //  - domain server memang salah/tidak ada.
        // Bedakan dengan probe ke host terkenal.
        if (await _adaInternet()) {
          throw ApiException(
              0, 'Server tidak dapat ditemukan (connection error).');
        }
        throw ApiException(0, 'Tidak ada koneksi internet.');
      }
      throw ApiException(0, 'Tidak ada koneksi internet.');
    } on TimeoutException {
      throw ApiException(0, 'Server tidak merespons (timeout).');
    }
  }

  // Probe konektivitas: cek apakah perangkat benar-benar punya internet.
  Future<bool> _adaInternet() async {
    try {
      final hasil = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return hasil.isNotEmpty && hasil.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  // Pesan ramah per-kelas HTTP error (skenario P5: 401 & 422).
  String _httpMessage(http.Response res) {
    final code = res.statusCode;
    final serverMsg = _extractMessage(res);
    switch (code) {
      case 401:
        return 'HTTP 401: API key tidak valid.';
      case 422:
        return 'HTTP 422: $serverMsg';
      default:
        return 'HTTP $code: $serverMsg';
    }
  }

  String _extractMessage(http.Response res) {
    try {
      final m = jsonDecode(res.body) as Map<String, dynamic>;
      return (m['message'] as String?) ?? 'HTTP ${res.statusCode}';
    } catch (_) {
      return 'HTTP ${res.statusCode}';
    }
  }
}