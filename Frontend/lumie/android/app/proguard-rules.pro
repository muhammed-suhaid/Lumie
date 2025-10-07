# Razorpay SDK fix
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep Proguard annotations
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers
