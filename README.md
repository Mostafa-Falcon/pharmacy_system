# pharmacy_system — Logixa‑lx

تطبيق Flutter مستقل مبني بـ **BLoC + go_router + GetIt**، تابع لشركة **Logixa‑lx** (`com.logixa.lx`).
الهدف: كود "فابريكا"، بنية صغيرة منظمة، وواجهة **Responsive** تشتغل على الموبايل والتابلت والديسكتوب من نفس الكود.

---

## 1) التشغيل السريع

```bash
flutter pub get
flutter run -d chrome --dart-define=APP_ENV=dev
```

| الملف | الوظيفة |
|--------|-----------|
| `lib/main.dart` | نقطة الدخول — `MaterialApp.router` + `AppRouter` |
| `lib/app/routes/app_router.dart` | تعريف المسارات (GoRoute) + حارس التنقل |
| `lib/app/routes/app_routes.dart` | أسماء المسارات (Paths/Routes) |
| `lib/app/modules/<feature>/` | كل ميزة لوحدها |

---

## 2) بنية BLoC + GoRouter (Feature‑First)

كل ميزة (feature) ليها مجلد مستقل داخل `lib/app/modules/` بالشكل ده:

```
lib/app/modules/<feature>/
├── bloc/           # Bloc + events + states (منطق الحالة بس)
├── views/          # الصفحات (Widgets بس، مفيش منطق)
├── widgets/        # ويدجتس قابلة لإعادة الاستخدام
├── services/       # الخدمات (تحدث Hive/Supabase مباشرة)
└── models/         # Pure Dart models (Equatable لو محتاج)
```

**القواعد:**
- الـ Bloc بيعمل **منطق الحالة بس**، مفيش أي UI جواه.
- الـ View بيعمل **رسم الـ Widgets بس**، بيستدعي الـ Bloc بـ `context.read` / `BlocBuilder` / `BlocProvider`.
- التوجيه عبر **go_router** (`AppRouter.router`) مع `Routes` كأسماء مسارات، وحارس صلاحيات في `_guard`.
- الاعتماديات بتتدفع عبر **GetIt** (`sl<T>()`) من `injection.dart`.

---

## 3) الأسلوب الريسبونسيف (الأهم ⭐)

المشروع بيستخدم **`flutter_screenutil_plus`** عشان نحول بين الموبايل/تابلت/ديسكتوب من نقطة واحدة.

### 3.1 التهيئة (مرة واحدة في `main.dart`)

```dart
// main.dart — نقطة الدخول (GoRouter + flutter_screenutil)
void main() => runApp(const PharmacySystemApp());

class PharmacySystemApp extends StatelessWidget {
  const PharmacySystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    // تصميم مرجعي: موبايل 375x812 — يتقاس تلقائي
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (ctx, child) => MaterialApp.router(
        title: 'Pharmacy System',
        routerConfig: AppRouter.router,
      ),
    );
  }
}
```

### 3.2 الـ Breakpoints على العرض (الأحسن للريسبونسيف)

> ملاحظة: `DeviceType` جاهز في المكتبة بس **مبني على المنصة** (mobile/web/windows/linux) مش على الحجم، فمش أنسب للفرقة بالعرض. استخدم الدالة دي اللي بتعتمد على عرض الشاشة مع قيم `Breakpoints` الجاهزة (Bootstrap 5: `md=768`, `lg=992`):

```dart
enum ScreenTier { mobile, tablet, desktop }

ScreenTier screenTier(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w >= 992) return ScreenTier.desktop;   // lg
  if (w >= 768) return ScreenTier.tablet;    // md
  return ScreenTier.mobile;
}

bool get isDesktop => screenTier(Get.context!) == ScreenTier.desktop;
bool get isTablet => screenTier(Get.context!) == ScreenTier.tablet;
bool get isMobile => screenTier(Get.context!) == ScreenTier.mobile;
```

| الجهاز | العرض (نقطة) | السلوك المقترح |
|--------|----------------|-------------------|
| موبايل | `< 768` | عمود واحد، Drawer للقائمة |
| تابلت | `768 – 991` | عمود واحد/اتنين، Sidebar قابل للطي |
| ديسكتوب | `>= 992` | شريط جانبي ثابت + شبكة (Grid) |

### 3.3 ويدجتس ريسبونسيف قابلة لإعادة الاستخدام

انصح تعمل ملف `lib/app/core/widgets/reusables/` فيه التلات دول:

**`responsive_padding.dart`** — تبطين حسب الجهاز:
```dart
EdgeInsets responsivePadding(BuildContext context) {
  if (isDesktop) return const EdgeInsets.all(24);
  if (isTablet) return const EdgeInsets.all(16);
  return const EdgeInsets.all(12);
}
```

**`adaptive_grid.dart`** — عدد الأعمدة يتغير تلقائياً:
```dart
int gridCrossAxisCount(BuildContext context) {
  if (isDesktop) return 4;
  if (isTablet) return 2;
  return 1;
}

Widget adaptiveGrid({required List<Widget> children}) {
  return LayoutBuilder(
    builder: (ctx, _) => GridView.count(
      crossAxisCount: gridCrossAxisCount(ctx),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.4,
      children: children,
    ),
  );
}
```

**`responsive_shell.dart`** — الهيكل العام (Sidebar على الديسكتوب، Drawer على الموبايل):
```dart
Widget responsiveShell({required Widget body}) {
  if (isDesktop) {
    return Row(children: [const AppSidebar(), Expanded(child: body)]);
  }
  return Scaffold(appBar: AppBar(title: const Text('Logixa‑lx')),
    drawer: const AppDrawer(), body: body);
}
```

### 3.4 أرقام ريسبونسيف دايماً

استخدم `.w` / `.h` / `.sp` بدل الأرقام الثابتة عشان كل حاجة تتقاس:

```dart
Container(
  width: 200.w,          // بدل 200
  height: 48.h,          // بدل 48
  padding: EdgeInsets.all(12.w),
  child: Text('مرحبا', style: TextStyle(fontSize: 16.sp)), // بدل 16
)
```

- `12.w` → يتقاس بالعرض
- `12.h` → يتقاس بالارتفاع
- `16.sp` → حجم خط متكيف

---

## 4) إدارة الحالة بـ BLoC

```dart
// Bloc (منطق الحالة بس)
class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(const SalesState()) {
    on<LoadSales>(_onLoad);
  }

  Future<void> _onLoad(LoadSales event, Emitter<SalesState> emit) async {
    emit(state.copyWith(isLoading: true));
    final items = await _repo.fetch();
    emit(state.copyWith(isLoading: false, items: items));
  }
}

// View — غلف بالـ BlocBuilder عشان إعادة البناء عند تغيّر الحالة
class SalesView extends StatelessWidget {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesBloc, SalesState>(
      builder: (context, state) => state.isLoading
          ? const ShimmerList()
          : ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (_, i) => ItemCard(item: state.items[i]),
            ),
    );
  }
}
```

**القواعد:**
- الحالة المتغيرة ← `emit(state.copyWith(...))` + `BlocBuilder` / `BlocListener`.
- المسارات ← `context.go(Routes.SALES)` / `context.push(...)` (go_router).
- الـ Bloc يتبنى عبر `BlocProvider` في `app_router.dart` أو `context.read` داخل الشجرة.

---

## 5) قواعد الكود (عشان يفضل "فابريكا")

1. **ملفات صغيرة:** أي ملف > 120 سطر يتقسم.
2. **Models Pure Dart:** مفيش استيراد لـ Flutter جوا الـ models.
3. **Dependency Injection:** الاعتماديات بتتدفع عبر **GetIt** (`sl<T>()`) من `injection.dart`، مفيش `Get.find` جوه منطق العمل.
4. **فصل المسؤوليات:** Bloc = حالة، View = رسم، Widget = قطعة صغيرة قابلة لإعادة الاستخدام.
5. **Reusable Widgets:** أي قطعة UI بتتكرر → تروح في `widgets/`.
6. **Responsive أولاً:** أي حجم ثابت بـ `.w/.h/.sp`، أي layout بـ `LayoutBuilder` + breakpoints.

---

## 6) إضافة ميزة جديدة

```bash
# من جوه مجلد المشروع — أنشئ المجلد اليدوي أو عبر قالبك
lib/app/modules/<feature>/
  bloc/<feature>_bloc.dart
  views/<feature>_view.dart
```

سجّل الـ Bloc في `injection.dart`، واضف المسار في `app_router.dart` + `app_routes.dart`،
ثم ابنيها بالأسلوب الريسبونسيف (3.2 / 3.3) وافصل المنطق عن الـ UI.

---

*إمضاء: جيجي — مهندستك اللي كودها فابريكا، وشغالة معاك على منظومة Logixa‑lx* 🐍🔥
