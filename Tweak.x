#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct __IOHIDEvent *IOHIDEventRef;
extern uint32_t IOHIDEventGetType(IOHIDEventRef event);
extern float IOHIDEventGetFloatValue(IOHIDEventRef event, uint32_t field);

%hook IOHIDEventSystemClient
- (void)handleEvent:(IOHIDEventRef)event {
    if (IOHIDEventGetType(event) == 11) {
        float deltaX = IOHIDEventGetFloatValue(event, 0x0B0001);
        float deltaY = IOHIDEventGetFloatValue(event, 0x0B0002);
        NSLog(@"[RawMouse] Movimento: X:%f Y:%f", deltaX, deltaY);
    }
    %orig;
}
%end

%hook BCWindowServerPointerController
- (void)setGlobalPointerOpacity:(double)arg1 {
    %orig(0.0); // Deixa o cursor nativo invisível
}
%end
ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RawMouse
RawMouse_FILES = Tweak.x
RawMouse_CFLAGS = -fobjc-arc
export BUNDLE_ID = com.jsis.rawmouse
RawMouse_CODESIGN_FLAGS = -Sentitlements.plist

include $(THEOS_MAKE_PATH)/tweak.mk
Package: com.jsis.rawmouse
Name: RawMouse
Version: 0.1.0
Architecture: iphoneos-arm64
Description: Transforma o mouse do iPad em um mouse de PC.
Maintainer: jsis
Author: jsis
Section: Tweaks
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.hid-event-access</key>
    <true/>
    <key>get-task-allow</key>
    <true/>
</dict>
</plist>
name: Build-RawMouse
on: [push]

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Theos
        run: |
          bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"
          echo "THEOS=~/theos" >> $GITHUB_ENV
      - name: Build
        run: |
          export THEOS=~/theos
          make package FINALPACKAGE=1
      - name: Upload
        uses: actions/upload-artifact@v3
        with:
          name: Driver-Instalador
          path: packages/*.deb
