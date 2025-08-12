import 'package:share_plus/share_plus.dart';

class ShareModule {
  Future<void> shareUrl({required ShareParams params}) => SharePlus.instance.share(params);

  Future<void> shareFile({required XFile file}) => SharePlus.instance.share(ShareParams(files: [file]));
}
