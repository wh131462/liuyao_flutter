import 'dart:io';

import 'package:path/path.dart' as path;

import 'utils.dart';

// 检查 Flutter 命令是否存在

void main() async {
  // 获取脚本所在目录的路径
  final rootPath = ScriptUtil.rootPath();
  // 定义要删除的文件或目录列表
  List<String> dirs = [
    "macos",
    "linux",
    "windows",
    "android",
    "web",
    "ios",
    "pubspec.lock",
    "schedule.iml",
    ".idea"
  ];

  // 遍历列表并检查每个项是否存在
  for (final item in dirs) {
    var p = path.join(rootPath, item); // 构建完整路径
    if (Directory(p).existsSync() || File(p).existsSync()) {
      // 如果文件或目录存在，则删除它
      try {
        await Directory(p).delete(recursive: true);
        print("Deleted file or directory [$item]");
      } catch (e) {
        print("Failed to delete [$item]: $e");
      }
    } else {
      print("[$item] does not exist, skipping.");
    }
  }
  Future<bool> _checkFlutterCommand() async {
    try {
      await Process.run('flutter', ['--version'],
          workingDirectory: rootPath, runInShell: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 检查 Flutter 命令是否存在
  if (await _checkFlutterCommand()) {
    // 执行 flutter clean
    ScriptUtil.runScript('flutter clean', rootPath, null, null);
    ScriptUtil.runScript('flutter pub get', rootPath, null, null);
    ScriptUtil.runScript('flutter create .', rootPath, null, null);
    print("The environment has been rebuilt.");
  } else {
    print(
        "Flutter command not found. Please ensure Flutter is installed and added to PATH.");
  }
}
