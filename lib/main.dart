import 'package:flutter/material.dart';
import 'app.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化儲存服務
  final storage = StorageService();
  await storage.init();

  runApp(HabitHeroApp(storage: storage));
}
