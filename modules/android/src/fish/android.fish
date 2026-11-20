set -x ANDROID_USER_HOME $XDG_DATA_HOME/android
set -x ANDROID_EMULATOR_HOME $XDG_DATA_HOME/android
# adb ignores ANDROID_USER_HOME and authenticates with ~/.android/adbkey.
# Also offer the key the emulator authorizes.
set -x ADB_VENDOR_KEYS $ANDROID_USER_HOME/adbkey
