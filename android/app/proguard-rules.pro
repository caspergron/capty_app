# R8/ProGuard rules to prevent stripping of SLF4J components.
# This is often needed when libraries like Pusher Channels' Android SDK
# use SLF4J for logging.
-keep class org.slf4j.** { *; }
-dontwarn org.slf4j.**

# If you are using Logback or another specific SLF4J implementation,
# you might also need rules for it. For example, for Logback-Android:
# -keep class ch.qos.logback.** { *; }
# -dontwarn ch.qos.logback.**