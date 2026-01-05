# Flutter 國際化配置指南

> 使用 Flutter Intl 插件實現多語言支援

---

## 步驟 1：安裝 Plugin

1. 開啟 Android Studio
2. 前往 **File → Settings → Plugins**
3. 搜索 **Flutter Intl**
4. 點擊 **Install**
5. **Restart IDE** 重新啟動

---

## 步驟 2：設定專案

在 `pubspec.yaml` 中加入以下依賴：

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  flutter:
    sdk: flutter
```

執行 `flutter pub get` 安裝依賴。

---

## 步驟 3：初始化專案

1. 在功能表列的 **Tools** 下找到 **Flutter Intl**
2. 選擇 **Initialize for the project**

執行結束後效果如下：

### 自動生成的設定

**(1)** 在 `pubspec.yaml` 中會增加：

```yaml
flutter_intl:
  enabled: true
```

**(2)** 在 `lib` 資料夾下會增加兩個子資料夾：

```
lib/
├── generated/
│   └── intl/
│       ├── messages_all.dart
│       └── messages_en.dart
└── l10n/
    └── intl_en.arb
```

- `generated` - 自動生成的 Dart 程式碼
- `l10n` - 語言資源檔 (ARB 格式)

---

## 步驟 4：添加語言

1. **Tools → Flutter Intl → Add Locale**
2. 輸入語言代碼（如 `zh` 表示中文）

執行結束後會生成：

```
lib/
├── generated/
│   └── intl/
│       ├── messages_all.dart
│       ├── messages_en.dart
│       └── messages_zh.dart    // 新增
└── l10n/
    ├── intl_en.arb
    └── intl_zh.arb             // 新增
```

---

## 步驟 5：初始化 Flutter 國際化

在主頁面 `MaterialApp` 中加入國際化設定：

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...其他設定

      // 國際化委託
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      // 支援的語言
      supportedLocales: S.delegate.supportedLocales,

      home: MyHomePage(),
    );
  }
}
```

---

## 步驟 6：設定多種語言

### ARB 檔案格式

分別在 `intl_en.arb` 和 `intl_zh.arb` 下添加翻譯字串：

**intl_en.arb (英文)**
```json
{
  "appTitle": "My App",
  "hello": "Hello",
  "welcome": "Welcome to our app"
}
```

**intl_zh.arb (中文)**
```json
{
  "appTitle": "我的應用",
  "hello": "你好",
  "welcome": "歡迎使用我們的應用"
}
```

### 使用翻譯字串

在需要國際化的地方使用 `S.of(context)` 呼叫：

```dart
Text(S.of(context).appTitle)
Text(S.of(context).hello)
Text(S.of(context).welcome)
```

---

## 切換語言範例

### 使用 PopupMenuButton 切換語言

```dart
PopupMenuButton<Locale>(
  icon: Icon(Icons.language),
  onSelected: (Locale locale) {
    // 切換語言的回調函式
    onLanguageChanged(locale);
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      value: Locale('en'),
      child: Text('English'),
    ),
    PopupMenuItem(
      value: Locale('zh'),
      child: Text('中文'),
    ),
  ],
)
```

### 動態切換語言

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,  // 當前語言
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MyHomePage(onLanguageChanged: _changeLanguage),
    );
  }
}
```

---

## 常用語言代碼

| 語言 | 代碼 |
|------|------|
| 英文 | `en` |
| 中文 (簡體) | `zh` |
| 中文 (繁體) | `zh_TW` |
| 日文 | `ja` |
| 韓文 | `ko` |
| 法文 | `fr` |
| 德文 | `de` |
| 西班牙文 | `es` |

---

## 注意事項

1. 每次修改 ARB 檔案後，Flutter Intl 會自動重新生成 Dart 程式碼
2. 確保所有 ARB 檔案中的 key 名稱一致
3. 如果自動生成失敗，可以執行 **Tools → Flutter Intl → Regenerate**
4. ARB 檔案使用 JSON 格式，注意語法正確性

---

## 學習要點總結

- [ ] 安裝 Flutter Intl 插件
- [ ] 在 pubspec.yaml 加入 flutter_localizations 依賴
- [ ] 使用 Tools → Flutter Intl → Initialize 初始化專案
- [ ] 使用 Add Locale 添加支援的語言
- [ ] 在 MaterialApp 中設定 localizationsDelegates 和 supportedLocales
- [ ] 在 ARB 檔案中定義翻譯字串
- [ ] 使用 S.of(context).key 取得翻譯文字
