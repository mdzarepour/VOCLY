
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkService {
  SharePlus sharePlus = SharePlus.instance;

  Future<void> shareAppLink() async {
    try {
      final params = ShareParams(
        text: 'Check out this exiting vocabulary hero https://web.kilhouse.ir/',
      );
      await sharePlus.share(params);
    } catch (error) {
      return;
    }
  }

  Future<void> openDonationLink() async {
    try {
      final Uri url = Uri.parse('https://ko-fi.com/');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (error) {
      return;
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
      return;
    }
  }
}
