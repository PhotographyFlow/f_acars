// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get helloWorld => '你好世界！';

  @override
  String get home => '主页';

  @override
  String get settings => '设置';

  @override
  String get yourApiKey => '您的API密钥（不要分享给别人！）';

  @override
  String get apiKeyWrong => '确保输入正确的API密钥。';

  @override
  String get deleteApiKey => ' 删除API密钥';

  @override
  String get submit => '提交';

  @override
  String get language => '语言';
}
