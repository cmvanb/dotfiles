export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/android"
# adb ignores ANDROID_USER_HOME and authenticates with ~/.android/adbkey.
# Also offer the key the emulator authorizes.
export ADB_VENDOR_KEYS="$ANDROID_USER_HOME/adbkey"
