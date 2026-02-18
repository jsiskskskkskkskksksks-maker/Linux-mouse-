#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Isso resolve os erros de "unknown type" e "undeclared function" das suas fotos
extern "C" {
    typedef struct __IOHIDEvent *IOHIDEventRef;
    uint32_t IOHIDEventGetType(IOHIDEventRef event);
    float IOHIDEventGetFloatValue(IOHIDEventRef event, uint32_t field);
}

%hook IOHIDEventSystemClient
- (void)handleEvent:(IOHIDEventRef)event {
    if (event != NULL) {
        // 11 é o tipo de evento para movimento de ponteiro/mouse
        if (IOHIDEventGetType(event) == 11) {
            float deltaX = IOHIDEventGetFloatValue(event, 0x0B0001);
            float deltaY = IOHIDEventGetFloatValue(event, 0x0B0002);
            NSLog(@"[RawMouse] Movimento: X=%f Y=%f", deltaX, deltaY);
        }
    }
    %orig;
}
%end

%hook BCWindowServerPointerController
- (void)setGlobalPointerOpacity:(double)arg1 {
    %orig(0.0); // Esconde a bolinha do cursor nativo
}
%end
