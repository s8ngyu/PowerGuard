include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PowerGuardPrefs
PowerGuardPrefs_FILES = PWGPreferenceController.m
PowerGuardPrefs_INSTALL_PATH = /Library/PreferenceBundles
PowerGuardPrefs_FRAMEWORKS = UIKit
PowerGuardPrefs_PRIVATE_FRAMEWORKS = Preferences
PowerGuardPrefs_CFLAGS += -fobjc-arc
PowerGuardPrefs_LDFLAGS +=  -lCSPreferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PowerGuardPrefs.plist$(ECHO_END)
