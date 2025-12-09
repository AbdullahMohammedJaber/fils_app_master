import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(width: width, height: heigth * 0.06),
              itemBackAndTitle(context, title: "User Guide".tr()),
              SizedBox(width: width, height: heigth * 0.04),
              getLang() == 'en'
                  ? DefaultText('''
User Guide: How to Add an Auction:

1. Open the Auction Section
- Navigate to the “Auctions” tab in the app.
- Tap the “+ Add Auction” button.

2. Fill in the Required Auction Information:
- Auction Title
- Description
- Starting Price
- Bid Increment
- Auction Duration

3. Upload Images & Videos
- Add high-quality images and videos for your auction.

4. Adding Product Options & Variants
- You can add multiple options depending on your product.

5. Generate Variants Automatically
Once you add product options, the system will automatically generate variants.

Example:
- Red / Small
- Red / Medium
- Red / Large
- Blue / Small
… etc.

(You can manually edit or remove any variants if needed.)

6. Set Pricing & Stock for Each Variant
For each generated variant, enter:
- Starting Price
- Specific images

7. Review & Publish
- Double-check your auction details.
- Tap "Publish Auction" to make it live!
''', overflow: TextOverflow.visible)
                  : getLang() == 'ar'
                  ? const DefaultText('''
دليل المستخدم: كيفية إضافة مزاد

1. فتح قسم المزادات
- انتقل إلى تبويب "المزادات" في التطبيق.
- اضغط على زر "+ إضافة مزاد".

2. تعبئة معلومات المزاد المطلوبة:
- عنوان المزاد
- الوصف
- السعر الابتدائي
- قيمة الزيادة (Bid Increment)
- مدة المزاد

3. رفع الصور والفيديوهات
- قم بإضافة صور عالية الجودة (ويمكن إضافة فيديوهات إن وُجدت).

4. إضافة خيارات المنتج والخصائص (Variants)
- يمكنك إضافة عدة خيارات حسب طبيعة المنتج.

5. توليد الخصائص تلقائياً
بعد إضافة خيارات المنتج، سيقوم النظام تلقائياً بتوليد الخصائص (Variants) بناءً على اختيارك.

مثال:
- أحمر / صغير
- أحمر / متوسط
- أحمر / كبير
- أزرق / صغير
… إلخ

(ويمكنك تعديل أو حذف أي خاصية عند الحاجة.)

6. تحديد السعر والصور لكل خاصية
لكل خاصية يتم توليدها، قم بإدخال:
- السعر الابتدائي
- صور خاصة بهذه الخاصية

7. المراجعة والنشر
- تأكد من صحة جميع بيانات المزاد.
- اضغط على "نشر المزاد" ليصبح فعالاً.
''', overflow: TextOverflow.visible)
                  : getLang() == 'de'
                  ? const DefaultText('''
उपयोगकर्ता मार्गदर्शिका: नीलामी कैसे जोड़ें

1. नीलामी अनुभाग खोलें
- ऐप में "Auctions" टैब पर जाएँ।
- "+ Add Auction" बटन पर टैप करें।

2. आवश्यक नीलामी जानकारी भरें:
- नीलामी का शीर्षक (Auction Title)
- विवरण (Description)
- शुरुआती मूल्य (Starting Price)
- बोली वृद्धि (Bid Increment)
- नीलामी की अवधि (Auction Duration)

3. चित्र और वीडियो अपलोड करें
- उच्च गुणवत्ता वाली तस्वीरें और वीडियो जोड़ें।

4. उत्पाद विकल्प और प्रकार (Variants) जोड़ें
- आप अपने उत्पाद के अनुसार कई विकल्प जोड़ सकते हैं।

5. स्वचालित रूप से वेरिएंट जनरेट करना
उत्पाद विकल्प जोड़ने के बाद, सिस्टम आपके चयन के आधार पर वेरिएंट अपने आप बना देगा।

उदाहरण:
- लाल / छोटा
- लाल / मध्यम
- लाल / बड़ा
- नीला / छोटा
… आदि

(आप आवश्यकता के अनुसार किसी भी वेरिएंट को संपादित या हटाया जा सकता है।)

6. प्रत्येक वेरिएंट के लिए मूल्य और चित्र सेट करें
प्रत्येक वेरिएंट के लिए दर्ज करें:
- शुरुआती मूल्य
- उस वेरिएंट के लिए विशेष चित्र

7. समीक्षा करें और प्रकाशित करें
- अपने नीलामी विवरण की अच्छी तरह जाँच करें।
- "Publish Auction" पर टैप करें ताकि नीलामी लाइव हो जाए।
''', overflow: TextOverflow.visible)
                  : getLang() == 'fa'
                  ? const DefaultText('''
راهنمای کاربر: چگونه یک مزایده اضافه کنیم

1. باز کردن بخش مزایده‌ها
- به تب «مزایده‌ها» در برنامه بروید.
- روی دکمه «+ افزودن مزایده» ضربه بزنید.

2. تکمیل اطلاعات لازم برای مزایده:
- عنوان مزایده
- توضیحات
- قیمت اولیه
- میزان افزایش قیمت (Bid Increment)
- مدت زمان مزایده

3. بارگذاری تصاویر و ویدئوها
- تصاویر باکیفیت (و در صورت وجود ویدئو) اضافه کنید.

4. افزودن گزینه‌ها و ویژگی‌های محصول (Variants)
- می‌توانید بر اساس نوع محصول خود چندین گزینه اضافه کنید.

5. ایجاد خودکار ویژگی‌ها
پس از افزودن گزینه‌های محصول، سیستم به‌صورت خودکار ویژگی‌ها (Variants) را براساس انتخاب‌های شما ایجاد می‌کند.

مثال:
- قرمز / کوچک
- قرمز / متوسط
- قرمز / بزرگ
- آبی / کوچک
… و غیره

(در صورت نیاز می‌توانید هر ویژگی را ویرایش یا حذف کنید.)

6. تنظیم قیمت و تصاویر برای هر ویژگی
برای هر ویژگی ایجادشده، موارد زیر را وارد کنید:
- قیمت اولیه
- تصاویر مخصوص آن ویژگی

7. بازبینی و انتشار
- تمام جزئیات مزایده را به‌دقت بررسی کنید.
- روی «انتشار مزایده» ضربه بزنید تا مزایده فعال شود.
''', overflow: TextOverflow.visible)
                  : const DefaultText('''
صارف کی رہنمائی: نیلامی کیسے شامل کریں

1. نیلامی سیکشن کھولیں
- ایپ میں "Auctions" ٹیب پر جائیں۔
- "+ Add Auction" بٹن پر ٹیپ کریں۔

2. نیلامی کی ضروری معلومات درج کریں:
- نیلامی کا عنوان
- تفصیل
- ابتدائی قیمت (Starting Price)
- بولی میں اضافہ (Bid Increment)
- نیلامی کا دورانیہ

3. تصاویر اور ویڈیوز اپلوڈ کریں
- اعلیٰ معیار کی تصاویر (اور اگر موجود ہوں تو ویڈیوز) شامل کریں۔

4. پروڈکٹ کے اختیارات اور ویریئنٹس شامل کریں
- آپ اپنے پروڈکٹ کے مطابق متعدد اختیارات شامل کر سکتے ہیں۔

5. ویریئنٹس خودکار طور پر تیار کرنا
پروڈکٹ کے اختیارات شامل کرنے کے بعد، سسٹم آپ کے انتخاب کے مطابق ویریئنٹس خود ہی بنا دے گا۔

مثال:
- سرخ / چھوٹا
- سرخ / درمیانہ
- سرخ / بڑا
- نیلا / چھوٹا
… وغیرہ

(ضرورت پڑنے پر آپ کسی بھی ویریئنٹ کو ترمیم یا حذف کر سکتے ہیں۔)

6. ہر ویریئنٹ کے لیے قیمت اور تصاویر سیٹ کریں
ہر تیار شدہ ویریئنٹ کے لیے درج کریں:
- ابتدائی قیمت
- اس ویریئنٹ کی مخصوص تصاویر

7. جائزہ لیں اور شائع کریں
- نیلامی کی تمام تفصیلات اچھی طرح چیک کریں۔
- "Publish Auction" پر ٹیپ کریں تاکہ نیلامی لائیو ہو جائے۔
''', overflow: TextOverflow.visible),
            ],
          ),
        ),
      ),
    );
  }
}
