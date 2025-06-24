import 'package:http/http.dart' as http;
import 'dart:typed_data';

// Replace with your Worker endpoint
const String baseUrl = 'https://your-worker-name.your-subdomain.workers.dev';

Future<void> uploadFile(String fileName, Uint8List bytes) async {
  final response = await http.put(
    Uri.parse('$baseUrl/upload?key=$fileName'),
    headers: {'Content-Type': 'application/octet-stream'},
    body: bytes,
  );
  print('Upload: ${response.body}');
}

Future<Uint8List?> downloadFile(String fileName) async {
  final response = await http.get(Uri.parse('$baseUrl/download?key=$fileName'));
  if (response.statusCode == 200) return response.bodyBytes;
  print('Download failed: ${response.statusCode}');
  return null;
}

Future<void> deleteFile(String fileName) async {
  final response = await http.delete(Uri.parse('$baseUrl/delete?key=$fileName'));
  print('Delete: ${response.body}');
}

// To preview files (without downloading, reference the key used when uploading):
//Image.network("https://your-worker-url/download?key=my-image.jpg")