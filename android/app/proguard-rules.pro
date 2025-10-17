# Flutter-specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Prevent obfuscation of classes annotated with @Keep
-keep @androidx.annotation.Keep class * { *; }

# Additional optimization rules
-dontwarn io.flutter.embedding.**
-ignorewarnings

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Remove logging for smaller size
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}