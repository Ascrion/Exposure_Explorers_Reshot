import 'package:http/http.dart' as http;
import 'dart:typed_data';

// Replace with your Worker endpoint
const String baseUrl = 'https://file-fetcher-api.navodiths.workers.dev';

Future<List<dynamic>> uploadFile(String fileName, Uint8List bytes) async {
  final response = await http.put(
    Uri.parse('$baseUrl/upload?key=$fileName'),
    headers: {'Content-Type': 'application/octet-stream'},
    body: bytes,
  );
  if (response.statusCode == 200){
    return [response.statusCode,'$baseUrl/download?key=$fileName'];
  }else{
    return [response.statusCode,response.body];
  }
  
}

Future<Uint8List?> downloadFile(String fileName) async {
  final response = await http.get(Uri.parse('$baseUrl/download?key=$fileName'));
  if (response.statusCode == 200) return response.bodyBytes;
  //print('Download failed: ${response.statusCode}');
  return null;
}

Future<bool> deleteFileR2(String fileName) async {
  final response = await http.delete(Uri.parse('$baseUrl/delete?key=$fileName'));
  if (response.statusCode == 200){
    return true;
  }
  else{
    return false;
  }
}

// To preview files (without downloading, reference the key used when uploading):
//Image.network("https://your-worker-url/download?key=my-image.jpg")