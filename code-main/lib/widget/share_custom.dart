import 'package:share_plus/share_plus.dart';

void shareApp() {
    SharePlus.instance.share(
      ShareParams(
        text:
            '🐝 Learn coding with BeeCode!\n\nDownload now:\nhttps://play.google.com/store/apps/details?id=com.beecode.app',
        subject: 'Check out BeeCode!',
      ),
    );
  }