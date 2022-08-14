import 'package:url_launcher/url_launcher.dart';

class UrlManager {
  UrlManager(this.path, [this.mode = LaunchMode.inAppWebView]);

  final String path;
  final LaunchMode mode;

  Future<void> run() async {
    if (await canLaunchUrl(_uri)) {
      await launchUrl(_uri, mode: mode);
    } else {
      throw 'Could not launch ${_uri.path}';
    }
  }

  Uri get _uri => Uri.parse(path);
}
