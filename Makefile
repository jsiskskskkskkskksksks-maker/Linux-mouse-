ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RawMouse
RawMouse_FILES = Tweak.x
RawMouse_CFLAGS = -fobjc-arc
# ESSA LINHA É A CHAVE DO SUCESSO:
RawMouse_FRAMEWORKS = UIKit CoreFoundation IOKit

include $(THEOS_MAKE_PATH)/tweak.mk
