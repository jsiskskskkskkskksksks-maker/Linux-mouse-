ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MouseLinux
MouseLinux_FILES = main.m AppDelegate.m RootViewController.m
MouseLinux_FRAMEWORKS = UIKit CoreGraphics IOKit

include $(THEOS_MAKE_PATH)/application.mk
