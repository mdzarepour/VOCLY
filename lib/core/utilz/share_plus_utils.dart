import 'package:share_plus/share_plus.dart';

Future<void> openLink({required final String link}) async {
  await SharePlus.instance.share(ShareParams(uri: Uri.parse(link)));
}
