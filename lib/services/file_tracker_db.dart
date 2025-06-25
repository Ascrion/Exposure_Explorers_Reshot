import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/temp_db.dart';

const String baseUrl = 'https://exposure-explorers-file-db.navodiths.workers.dev';

// To temporarily store the db in memory
final fileTableProvider = StateProvider<List<FileRow>>((ref) => []);

Future<int> insertFile(Map<String, dynamic> file) async {
  final res = await http.post(
    Uri.parse('$baseUrl/files-insert'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(file),
  );
  return res.statusCode;
}

// Modified retrieve function to store table locally
Future<void> retrieveFiles(ref) async {
  final res = await http.get(Uri.parse('$baseUrl/files-retrieve'));
  if (res.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(res.body);
    ref.read(fileTableProvider.notifier).state = jsonList.map((e) => FileRow.fromJson(e)).toList();
  } else {
    throw Exception('Failed to retrieve files');
  }
}

Future<bool> updateFile(Map<String, dynamic> file) async {
  final res = await http.post(
    Uri.parse('$baseUrl/files-update'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(file),
  );
  return res.statusCode == 200;
}

Future<bool> deleteFile(int id) async {
  final res = await http.post(
    Uri.parse('$baseUrl/files-delete'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': id}),
  );
  return res.statusCode == 200;
}
