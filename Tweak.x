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
        NSLog(@"[RawMouse] X: %f Y: %f", deltaX, deltaY);
    }
    %orig;
}
%end

%hook BCWindowServerPointerController
- (void)setGlobalPointerOpacity:(double)arg1 {
    %orig(0.0);
}
%end
