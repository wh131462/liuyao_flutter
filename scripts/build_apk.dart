import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';  // 用于解析 pubspec.yaml

import 'utils.dart';

void main() async {
  // 获取脚本所在目录的路径
  final rootPath = ScriptUtil.rootPath();

  // 定义构建配置和输出目录，相对于脚本所在目录
  const buildPath = 'release';
  final outputDirectory = '$rootPath/$buildPath';

  // 确保输出目录存在
  Directory(outputDirectory).createSync(recursive: true);

  // 读取 pubspec.yaml 文件
  final pubspecFile = File(path.join(rootPath, 'pubspec.yaml'));
  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspec = loadYaml(pubspecContent);

  // 获取版本号
  final version = pubspec['version'] as String?;
  if (version == null) {
    print('Failed to read version from pubspec.yaml');
    exit(1);
  }

  print("Current workspace: $rootPath");
  ScriptUtil.runScript(
      "flutter build apk --release", rootPath,
          () async {
        var apkPath = path.join(
            rootPath, 'build', 'app', 'outputs', 'flutter-apk', 'app-release.apk');
        var targetPath = path.join(outputDirectory, 'liuyao_$version.apk');
        await File(apkPath).rename(targetPath);

        // 打印成功信息
        print('APK has been built successfully at: file://$targetPath');
      }, () {
    print('Script run failed.');
    exit(1);
  });
}
