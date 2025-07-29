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
  String get yourVaUrl => '您的 VA 链接（不要在末尾添加\'/\'）';

  @override
  String get invalidUrl => '无效的链接';

  @override
  String get delete => ' 删除';

  @override
  String get submit => '提交';

  @override
  String get save => '保存';

  @override
  String get testConnection => '连接测试';

  @override
  String get test => '测试';

  @override
  String get testOK => '✓ 成功';

  @override
  String get eCheckVA => '失败，检查您的 VA 链接';

  @override
  String get e401 => '错误 401 未授权, 检查您的 API 密钥和 VA 链接';

  @override
  String get e404 => '错误 404 请求不存在, 检查您的 VA 链接';

  @override
  String get e400 => '错误 400 验证错误, 联系开发者';

  @override
  String get eInternet => '失败, 检查您的网络连接和 VA 链接设置';

  @override
  String get language => '语言';

  @override
  String get weightUnit => '重量单位';
}
