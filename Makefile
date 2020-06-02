ARCHS = arm64 arm64e
FINALPACKAGE = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NiceSettings
NiceSettings_FILES = Tweak.xm
NiceSettings_PRIVATE_FRAMEWORKS = Preferences
NiceSettings_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp NiceSettingsPrefs.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NiceSettingsPrefs.plist$(ECHO_END)
	$(ECHO_NOTHING)cp -r Resources $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NiceSettingsPrefs.Resources$(ECHO_END)
