import 'dart:convert';
import 'dart:io';

String readStringFixture(String filename) {
  final file = File('test/fixtures/$filename');
  return file.readAsStringSync();
}

dynamic readJsonFixture(String filename) {
  final stringFixture = readStringFixture(filename);
  return jsonDecode(stringFixture);
}
