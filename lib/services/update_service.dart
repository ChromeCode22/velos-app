import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ota_update/ota_update.dart';

class UpdateService {
  static const String checkUpdateUrl = 'https://sua-api.com/velos/version.json';

  static Future<void> checkForUpdates(Function(String) onNewVersionFound) async {
    try {
      final response = await http.get(Uri.parse(checkUpdateUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String latestVersion = data['version'];
        String apkUrl = data['apk_url'];

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion = packageInfo.version;

        if (latestVersion != currentVersion) {
          onNewVersionFound(apkUrl);
        }
      }
    } catch (e) {
      print('Erro ao verificar atualização: $e');
    }
  }

  static void downloadAndInstallApk(String url) {
    try {
      OtaUpdate().execute(url, destinationFilename: 'velos_update.apk').listen(
        (OtaEvent event) {
          print('Status do Download: ${event.status} - ${event.value}%');
        },
      );
    } catch (e) {
      print('Erro ao instalar APK: $e');
    }
  }
}
