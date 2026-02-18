ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RawMouse
RawMouse_FILES = Tweak.x
RawMouse_CFLAGS = -fobjc-arc
# ESTA LINHA É A CHAVE PARA RESOLVER O ERRO DE LINKING:
RawMouse_FRAMEWORKS = UIKit CoreFoundation IOKit

include $(THEOS_MAKE_PATH)/tweak.mk
