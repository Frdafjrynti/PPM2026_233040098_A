import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' show Catatan;

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();
  static const _key = 'catatan_list';

  Future<List<Catatan>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final result = <Catatan>[];
    for (final s in raw) {
      try {
        result.add(Catatan.fromMap(jsonDecode(s) as Map<String, Object?>));
      } catch (_) {}
    }
    return result;
  }

  Future<void> insert(Catatan c) async {
    final list = await getAll();
    final newCatatan = Catatan(
      id: DateTime.now().millisecondsSinceEpoch,
      judul: c.judul,
      email: c.email,
      isi: c.isi,
      kategori: c.kategori,
      dibuatPada: c.dibuatPada,
      diubahPada: null,
    );
    list.insert(0, newCatatan);
    await _simpan(list);
  }

  Future<void> update(Catatan c) async {
    final list = await getAll();
    final idx = list.indexWhere((e) => e.id == c.id);
    if (idx != -1) list[idx] = c;
    await _simpan(list);
  }

  Future<void> delete(int id) async {
    final list = await getAll();
    list.removeWhere((e) => e.id == id);
    await _simpan(list);
  }

  Future<void> _simpan(List<Catatan> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      list.map((c) => jsonEncode(c.toMap())).toList(),
    );
  }
}