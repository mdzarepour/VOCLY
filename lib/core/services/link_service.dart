import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocly/core/error/app_exeption.dart';

class LinkService {
  final SharePlus sharePlus;
  LinkService({required this.sharePlus});

  AppExeption _wrapException(Object error, {required String message}) {
    if (error is AppExeption) {
      return error;
    }
    return AppExeption(
      message: message,
      cause: error,
      stackTrace: StackTrace.current,
    );
  }

  Future<void> shareAppLink() async {
    try {
      final params = ShareParams(
        text: 'Check out this exiting vocabulary hero https://web.kilhouse.ir/',
      );
      await sharePlus.share(params);
    } catch (error) {
      throw _wrapException(error, message: 'Failed to share app link');
    }
  }

  Future<void> openDonationLink() async {
    try {
      final Uri url = Uri.parse('https://ko-fi.com/');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (error) {
      throw _wrapException(error, message: 'Failed to open donation link');
    }
  }

  Future<void> sendEmail() async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'mdzarepour@gmail.com',
      );
      await launchUrl(emailLaunchUri);
    } catch (error) {
      throw _wrapException(error, message: 'Failed to send email');
    }
  }
}
