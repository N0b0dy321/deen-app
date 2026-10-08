# flutter_local_notifications: กัน R8 ตัด class/generic ที่ปลั๊กอินใช้เก็บแจ้งเตือนที่ตั้งเวลาไว้
# (ถ้าไม่มี แจ้งเตือนจะทำงานตอน debug แต่เงียบในไฟล์ release)
-keep class com.dexterous.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepattributes Signature
-keepattributes *Annotation*