# Razorpay SDK fix
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep Proguard annotations
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# Google Mobile Ads (AdMob) - keep ads SDK classes when minify is enabled
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Mediation adapters (optional but helpful if used)
-keep class com.google.ads.mediation.** { *; }
-dontwarn com.google.ads.mediation.**
