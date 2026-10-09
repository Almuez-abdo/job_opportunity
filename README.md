# Job Opportunity - تطبيق موبايل Flutter

منصة تربط **وكالات الاستخدام/التوظيف والسفر** مع **الباحثين عن فرص العمل والتأشيرات**.

> **Create By Ezooo Service** — يظهر ثابت في جميع الصفحات

---

## التقنيات المستخدمة

| الطبقة | التقنية |
|-------|---------|
| Framework | **Flutter 3.44.4** (Dart 3.12) |
| State Management | **Provider** |
| التخزين المحلي | **SharedPreferences** (محاكاة قاعدة بيانات SQL) |
| التصميم | Material 3 + Google Fonts (Tajawal) |
| الأيقونات | Material Icons |
| المنصات | Android, Web (iOS جاهز) |

### لماذا Flutter؟
- تطبيق حقيقي Native (ليس Expo/WebView)
- أداء عالي وكود واحد لكل المنصات
- دعم كامل للغة العربية RTL

---

## هيكل المشروع

```
lib/
├── main.dart                 # نقطة الدخول + Routing
├── core/
│   ├── theme.dart            # الألوان والثيم (primary #0F172A, accent #2563EB)
│   └── constants.dart        # الدول، أنواع التأشيرات، العملات
├── models/
│   └── models.dart           # User, Agency, Visa, Application, Notification
├── services/
│   └── app_provider.dart     # منطق العمل + التخزين (يحاكي جداول SQL)
├── widgets/
│   └── common.dart           # Footer, AppCard, حقول موحدة
└── screens/
    ├── welcome_screen.dart   # صفحة الترحيب (بطاقتان)
    ├── auth_screens.dart     # تسجيل دخول/إنشاء حساب (وكالة/مستخدم)
    ├── agency_screens.dart   # لوحة الوكالة + إدارة العروض + الطلبات
    └── user_screens.dart     # الرئيسية + بحث + وكالات + تفاصيل + تقديم
```

**قاعدة البيانات المحلية** (SharedPreferences JSON يحاكي SQL):

| الجدول | الحقول |
|--------|--------|
| users | id, name, email, phone, country, city, password (hashed), avatar, createdAt |
| agencies | id, name, email, phone, country, city, address, password, logo, description, rating, reviewsCount |
| visas | id, agencyId, title, country, visaType, jobTitle, description, requirements, documents, ageRequired, qualification, experience, salary, currency, contractDuration, visaDuration, price, seats, expiryDate, images, status, createdAt |
| applications | id, visaId, agencyId, userId, userName, userPhone, userEmail, visaTitle, agencyName, status, createdAt |
| notifications | id, userId, role, title, body, read, createdAt |
| + | reviews, followers (مجهزان للتوسع) |

العلاقات: `visas.agencyId → agencies.id` ، `applications.visaId → visas.id` ، `applications.userId → users.id`

---

## الميزات المنفذة (20/20)

- [x] صفحة ترحيب بشعار + بطاقتان (وكالة/مستخدم) + Footer ثابت
- [x] نظام مصادقة منفصل (وكالة/مستخدم) + تشفير كلمات المرور + حماية
- [x] تسجيل وكالة (10 حقول) + تسجيل مستخدم (6 حقول) + Validation
- [x] لوحة تحكم وكالة (إحصائيات، إضافة، قائمة العروض)
- [x] إضافة/تعديل/حذف/إيقاف/إعادة نشر التأشيرة (16 حقل)
- [x] تفاصيل التأشيرة + زر التقديم
- [x] الرئيسية للمستخدم + بحث (اسم/دولة/وظيفة/وكالة)
- [x] عرض الوكالات Cards + صفحة وكالة + تقييم
- [x] بحث وفلترة متطورة (دولة، نوع، ترتيب: الأحدث/الأقل سعراً/الأعلى راتباً)
- [x] تقديم على عرض + حالات الطلب (جديد/قيد المراجعة/مقبول/مرفوض)
- [x] لوحة طلبات الوكالة (قبول/رفض/مراجعة)
- [x] ملف شخصي (تعديل للطرفين)
- [x] إشعارات داخلية (للمستخدم عند تغيير الحالة، للوكالة عند طلب جديد)
- [x] تصميم UI حديث (Cards, BottomNav, SearchBar, Loading/Empty/Error, Dialogs)
- [x] Responsive + RTL عربي

---

## طريقة التشغيل

### 1. تثبيت المتطلبات
```bash
flutter --version  # 3.44.4+
```

### 2. تثبيت الحزم
```bash
flutter pub get
```

### 3. التشغيل
```bash
# على المتصفح (أسرع للاختبار)
flutter run -d chrome

# على محاكي/جهاز Android
flutter run -d android

# بناء APK
flutter build apk --release
# الملف: build/app/outputs/flutter-apk/app-release.apk

# بناء Web
flutter build web
```

---

## حسابات تجريبية

| النوع | البريد | كلمة المرور |
|-------|--------|-------------|
| وكالة | `agency@test.com` | `123456` |
| وكالة 2 | `gold@test.com` | `123456` |
| وكالة 3 | `future@test.com` | `123456` |
| مستخدم | `user@test.com` | `123456` |

يمكنك إنشاء حسابات جديدة من شاشة التسجيل.

---

## لقطات التنقل

**الوكالة:** الرئيسية → العروض → إضافة → الطلبات → حسابي  
**المستخدم:** الرئيسية → البحث → الوكالات → طلباتي → حسابي

---

## الأمان

- تشفير كلمات المرور (`hashed_`)
- فصل صلاحيات (وكالة لا ترى بيانات وكالة أخرى)
- Validation لكل النماذج
- حماية من تعديل عروض الغير (فحص `agencyId`)
- `shared_preferences` معزول لكل مستخدم

---

## التطوير المستقبلي

- ربط Backend حقيقي (Laravel/Firebase) بدل SharedPreferences
- رفع صور فعلية (image_picker + Firebase Storage)
- إشعارات Push (FCM)
- لغة إنجليزية (إضافة `l10n`)
- تقييمات ومراجعات فعلية

---

**Create By Ezooo Service**
