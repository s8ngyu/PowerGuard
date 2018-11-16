ARCHS = armv7 arm64
DEBUG=0
FINALPACKAGE=1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PowerGuard
PowerGuard_FILES = Tweak.xm
PowerGuard_FRAMEWORKS = UIKit
PowerGuard_LDFLAGS +=  -lCSPreferencesProvider

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += Prefs

include $(THEOS_MAKE_PATH)/aggregate.mk
