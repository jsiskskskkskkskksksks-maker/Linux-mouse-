ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RawMouse
RawMouse_FILES = Tweak.x
RawMouse_CFLAGS = -fobjc-arc
export BUNDLE_ID = com.jsis.rawmouse
RawMouse_CODESIGN_FLAGS = -Sentitlements.plist

include $(THEOS_MAKE_PATH)/tweak.mk

