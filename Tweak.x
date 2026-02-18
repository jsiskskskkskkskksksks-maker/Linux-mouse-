#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Isso resolve o erro "unknown type name" das suas fotos
extern "C" {
    typedef struct __IOHIDEvent *IOHIDEventRef;
    uint32_t IOHIDEventGetType(IOHIDEventRef event);
    float IOHIDEventGetFloatValue(IOHIDEventRef event, uint32_t field);
}

%hook IOHIDEventSystemClient
- (void)handleEvent:(IOHIDEventRef)event {
    if (event != NULL && IOHIDEventGetType(event) == 11) {
        // Captura o movimento bruto (Raw Input)
        float deltaX = IOHIDEventGetFloatValue(event, 0x0B0001);
        float deltaY = IOHIDEventGetFloatValue(event, 0x0B0002);
        NSLog(@"[RawMouse] X: %f Y: %f", deltaX, deltaY);
    }
    %orig;
}
%end

%hook BCWindowServerPointerController
- (void)setGlobalPointerOpacity:(double)arg1 {
    %orig(0.0); // Esconde a bolinha cinza nativa
}
%end
