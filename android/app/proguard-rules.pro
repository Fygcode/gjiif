# Fix R8 missing javax.xml.stream issue
-dontwarn javax.xml.stream.**
-keep class javax.xml.stream.** { *; }

# If apache-tika is not used at runtime, ignore it
-dontwarn org.apache.tika.**

# Cashfree SDK safety (keep JNI + reflection classes)
-keep class com.cashfree.** { *; }
-keepattributes *Annotation*
