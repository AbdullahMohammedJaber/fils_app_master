#!/bin/bash

# اسم الباكيج القديم والجديد
OLD_PACKAGE="com.example.fils"
NEW_PACKAGE="com.app.fils"

# المسار لجذر المشروع
PROJECT_DIR="$(pwd)"

# المسار لملفات Kotlin
KOTLIN_DIR="$PROJECT_DIR/android/app/src/main/kotlin"

# استبدال نقاط الباكيج بمجلدات
OLD_PATH="$KOTLIN_DIR/$(echo $OLD_PACKAGE | tr '.' '/')"
NEW_PATH="$KOTLIN_DIR/$(echo $NEW_PACKAGE | tr '.' '/')"

echo "✅ تغيير الباكيج من $OLD_PACKAGE إلى $NEW_PACKAGE"

# إنشاء المجلد الجديد
mkdir -p "$NEW_PATH"

# نقل MainActivity.kt
if [ -f "$OLD_PATH/MainActivity.kt" ]; then
    mv "$OLD_PATH/MainActivity.kt" "$NEW_PATH/MainActivity.kt"
    echo "✔ تم نقل MainActivity.kt"
else
    echo "⚠ MainActivity.kt غير موجود في $OLD_PATH"
fi

# حذف المجلد القديم إذا فارغ
rm -rf "$KOTLIN_DIR/$(echo $OLD_PACKAGE | cut -d'.' -f1-2)"
echo "✔ تم حذف المجلد القديم"

# تحديث package داخل MainActivity.kt
sed -i "s/package $OLD_PACKAGE/package $NEW_PACKAGE/" "$NEW_PATH/MainActivity.kt"
echo "✔ تم تعديل package داخل MainActivity.kt"

# تحديث AndroidManifest.xml
MANIFEST="$PROJECT_DIR/android/app/src/main/AndroidManifest.xml"
sed -i "s/package=\"$OLD_PACKAGE\"/package=\"$NEW_PACKAGE\"/" "$MANIFEST"
echo "✔ تم تعديل package داخل AndroidManifest.xml"

# تحديث build.gradle
BUILD_GRADLE="$PROJECT_DIR/android/app/build.gradle"
sed -i "s/applicationId \"$OLD_PACKAGE\"/applicationId \"$NEW_PACKAGE\"/" "$BUILD_GRADLE"
echo "✔ تم تعديل applicationId داخل build.gradle"

# تنظيف المشروع وإعادة بناء
flutter clean
flutter pub get
flutter build apk

echo "🎉 تم الانتهاء! مشروعك جاهز الآن بالباكيج الجديد."
