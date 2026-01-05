# Flutter 多頁面應用 - 自傳 App

> 課程日期：114/10/13
> 對應專案：`1141013autobiography/`

---

## 教學重點

### 1. BottomNavigationBar 底部導航列

```dart
class _MyHomePageState extends State<MyHomePage> {
  final tabs = [
    const SelfIntroductionScreen(),
    const LearningJourneyScreen(),
    const StudyPlanScreen(),
    const ProfessionalDirectionScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],  // 顯示當前頁面
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  // 固定型態 (超過3個項目時需設定)
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        selectedFontSize: 18,
        unselectedFontSize: 14,
        iconSize: 30,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: '自我介紹'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '學習歷程'),
          BottomNavigationBarItem(icon: Icon(Icons.scale_outlined), label: '讀書計畫'),
          BottomNavigationBarItem(icon: Icon(Icons.engineering), label: '專業方向'),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
```

**BottomNavigationBar 屬性：**
| 屬性 | 說明 |
|------|------|
| `type` | `fixed` 固定 / `shifting` 浮動 |
| `currentIndex` | 當前選中的索引 |
| `items` | 導航項目列表 |
| `onTap` | 點擊回調 |
| `selectedItemColor` | 選中項目顏色 |
| `unselectedItemColor` | 未選中項目顏色 |

### 2. 動態語言切換 (Callback 函式)

```dart
// MyApp 中定義語言狀態和切換方法
class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('zh');  // 預設中文

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,  // 當前語言
      // ...
      home: MyHomePage(onLocaleChange: setLocale),  // 傳遞 callback
    );
  }
}

// MyHomePage 接收並使用 callback
class MyHomePage extends StatefulWidget {
  final Function(Locale) onLocaleChange;  // 接收函式參數
  const MyHomePage({super.key, required this.onLocaleChange});
  // ...
}
```

### 3. PopupMenuButton 彈出選單

```dart
AppBar(
  actions: <Widget>[
    PopupMenuButton<Locale>(
      onSelected: (Locale locale) {
        widget.onLocaleChange(locale);  // 呼叫父層的 callback
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('zh'),
          child: Text('中文'),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Text('English'),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('ja'),
          child: Text('日本語'),
        ),
      ],
      icon: const Icon(Icons.language),  // 語言圖示
    ),
  ],
),
```

### 4. 專案結構化 - 分離 Screen 檔案

```
lib/
├── main.dart                     # 主程式 (App 入口 + 導航)
├── screens/
│   ├── self_introduction_screen.dart    # 自我介紹頁
│   ├── learning_journey_screen.dart     # 學習歷程頁
│   ├── study_plan_screen.dart           # 讀書計畫頁
│   └── professional_direction_screen.dart  # 專業方向頁
└── generated/
    └── l10n/
        └── app_localizations.dart       # 國際化
```

**引入方式：**
```dart
import 'package:auto11410131/screens/self_introduction_screen.dart';
import 'package:auto11410131/screens/learning_journey_screen.dart';
```

### 5. Card 卡片元件

```dart
Card(
  elevation: 4,  // 陰影高度
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),  // 圓角
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('標題', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('內容...'),
      ],
    ),
  ),
),
```

### 6. ListView 列表視圖

```dart
ListView(
  padding: const EdgeInsets.all(16.0),
  children: <Widget>[
    _buildProfileHeader(localizations),
    const SizedBox(height: 20),
    _buildSummaryCard(localizations),
    const SizedBox(height: 20),
    _buildContactCard(localizations),
  ],
),
```

### 7. CircleAvatar 圓形頭像

```dart
CircleAvatar(
  radius: 60,  // 半徑
  backgroundImage: AssetImage('assets/images/photo.jpg'),
),
```

### 8. ListTile 列表項目

```dart
ListTile(
  leading: const Icon(Icons.email, color: Colors.blueAccent),
  title: Text('Email'),
  subtitle: const Text('example@email.com'),
),
```

### 9. Chip 標籤元件

```dart
Wrap(
  spacing: 8.0,      // 水平間距
  runSpacing: 4.0,   // 垂直間距
  children: [
    Chip(label: Text('Java')),
    Chip(label: Text('Python')),
    Chip(label: Text('Dart'), backgroundColor: Colors.blue.shade100),
  ],
),
```

### 10. 私有方法建構子模式

```dart
class SelfIntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _buildProfileHeader(localizations),  // 呼叫私有方法
          _buildSummaryCard(localizations),
          _buildContactCard(localizations),
        ],
      ),
    );
  }

  // 私有方法 (底線開頭)
  Widget _buildProfileHeader(AppLocalizations localizations) {
    return Column(
      children: [
        CircleAvatar(...),
        Text(localizations.profileName),
      ],
    );
  }

  Widget _buildSummaryCard(AppLocalizations localizations) {
    return Card(...);
  }
}
```

### 11. 隱藏 Debug 標籤

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,  // 隱藏右上角的 DEBUG 標籤
  // ...
)
```

### 12. 使用主題顏色

```dart
AppBar(
  backgroundColor: Theme.of(context).colorScheme.inversePrimary,  // 使用主題反轉色
)
```

**常用 ColorScheme 屬性：**
| 屬性 | 說明 |
|------|------|
| `primary` | 主要顏色 |
| `secondary` | 次要顏色 |
| `inversePrimary` | 主要顏色的反轉色 |
| `surface` | 表面顏色 |
| `error` | 錯誤顏色 |

### 13. TextStyle 行間距

```dart
Text(
  '多行文字內容...',
  style: TextStyle(
    fontSize: 16,
    height: 1.5,  // 行間距倍數 (1.5 = 1.5倍行高)
  ),
),
```

### 14. Divider 分隔線進階

```dart
Divider(
  height: 1,        // 分隔線佔用高度
  indent: 16,       // 左側縮排
  endIndent: 16,    // 右側縮排
  color: Colors.grey,  // 顏色 (選填)
),
```

### 15. Flutter 內建國際化 (flutter gen-l10n)

此專案使用 Flutter 內建的國際化方式（與 BMI v3 的 Flutter Intl 插件不同）：

```dart
// 引入方式
import 'package:auto11410131/generated/l10n/app_localizations.dart';

// 使用方式
AppLocalizations.of(context)!.appBarTitle

// MaterialApp 配置
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: _locale,
)
```

**Flutter Intl vs flutter gen-l10n：**
| 項目 | Flutter Intl | flutter gen-l10n |
|------|-------------|------------------|
| 設定方式 | IDE 插件 | 內建指令 |
| 使用類別 | `S.of(context)` | `AppLocalizations.of(context)` |
| 翻譯檔 | `lib/l10n/*.arb` | `lib/l10n/*.arb` |

---

## 使用的 Widget 清單

| Widget | 用途 |
|--------|------|
| `BottomNavigationBar` | 底部導航列 |
| `BottomNavigationBarItem` | 導航項目 |
| `PopupMenuButton` | 彈出選單按鈕 |
| `PopupMenuItem` | 選單項目 |
| `Card` | 卡片容器 |
| `ListView` | 可捲動列表 |
| `ListTile` | 列表項目 |
| `CircleAvatar` | 圓形頭像 |
| `Chip` | 標籤 |
| `Wrap` | 自動換行容器 |
| `Divider` | 分隔線 |
| `IntrinsicHeight` | 內在高度約束 |

---

## 設計模式

### Callback 傳遞模式
```
MyApp (持有狀態: _locale)
  │
  ├── setLocale() 方法
  │
  └── MyHomePage (接收 onLocaleChange callback)
        │
        └── PopupMenuButton
              │
              └── onSelected → 呼叫 widget.onLocaleChange()
                    │
                    └── 觸發 MyApp 的 setState() → 重建 UI
```

### 頁面切換模式
```
tabs[0] ←── currentIndex = 0
tabs[1] ←── currentIndex = 1
tabs[2] ←── currentIndex = 2
tabs[3] ←── currentIndex = 3

onTap(index) → setState() → currentIndex = index → body: tabs[currentIndex]
```

---

## 學習要點總結

- [ ] 了解 `BottomNavigationBar` 的使用方式
- [ ] 掌握 `type: BottomNavigationBarType.fixed` 的時機
- [ ] 使用 `PopupMenuButton` 建立下拉選單
- [ ] 理解 Callback 函式在元件間傳遞的模式
- [ ] 學會將 Screen 分離到獨立檔案
- [ ] 使用 `Card` 建立卡片式 UI
- [ ] 使用 `ListView` 建立可捲動頁面
- [ ] 使用 `Chip` 和 `Wrap` 顯示標籤列表
- [ ] 了解私有方法 (`_buildXxx`) 的建構模式
- [ ] 動態切換 App 語言的實作方式
- [ ] 使用 `debugShowCheckedModeBanner: false` 隱藏 DEBUG 標籤
- [ ] 使用 `Theme.of(context).colorScheme` 取得主題顏色
- [ ] 使用 `TextStyle.height` 設定行間距
- [ ] 了解 Flutter 內建國際化與 Flutter Intl 的差異
