
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnerSupportController extends GetxController {

  static Future<void> makeCall(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      Get.snackbar("Error", "Could not open phone dialer");
    }
  }

  static Future<void> launchEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      Get.snackbar("Error", "Could not open email app");
    }
  }

  static Future<void> openWhatsApp(String number) async {
    final Uri uri = Uri.parse("https://wa.me/$number");

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      Get.snackbar("Error", "Could not open WhatsApp");
    }
  }
}