#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Declarações simples para o robô não travar
typedef struct __IOHIDEvent *IOHIDEventRef;
uint32_t IOHIDEventGetType(IOHIDEventRef event);
float IOHIDEventGetFloatValue(IOHIDEventRef event, uint32_t field);

%hook IOHIDEventSystemClient
- (void)handleEvent:(IOHIDEventRef)event {
    if (event != NULL) {
        // 11 é o código para movimento de mouse
        if (IOHIDEventGetType(event) == 11) {
            float dx = IOHIDEventGetFloatValue(event, 0x0B0001);
            float dy = IOHIDEventGetFloatValue(event, 0x0B0002);
            NSLog(@"[RawMouse] Mouse movido: X=%f Y=%f", dx, dy);
        }
    }
    %orig;
}
%end

%hook BCWindowServerPointerController
- (void)setGlobalPointerOpacity:(double)arg1 {
    %orig(0.0); // Esconde a bolinha do cursor
}
%end
