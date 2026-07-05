import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocly/core/error/app_exception.dart';

class LinkService {
  final SharePlus sharePlus;
  LinkService({required this.sharePlus});

  // ================ Share Plus Function ======================================

  Future<void> shareAppLink() async {
    try {
      final params = ShareParams(
        text: 'Check out this exiting vocabulary hero https://web.kilhouse.ir/',
      );
      await sharePlus.share(params);
    } catch (error) {
      throw AppError(errorMessage: 'Failed to share app link', cause: error);
    }
  }
  // ================ Url Luncher Function =====================================

  Future<void> openDonationLink() async {
    try {
      final Uri url = Uri.parse('https://ko-fi.com/');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (error) {
      throw AppError(
        errorMessage: 'Failed to open donation link',
        cause: error,
      );
    }
  }

  Future<void> openBookLibraryPage() async {
    try {
      final Uri url = Uri.parse('https://mdzarepour.github.io/vocly_download/');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (error) {
      throw AppError(errorMessage: 'Failed to open web link', cause: error);
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
      throw AppError(errorMessage: 'Failed to send email', cause: error);
    }
  }
}
