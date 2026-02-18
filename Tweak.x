#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Isso diz ao compilador para procurar as funções no sistema do iPad
extern "C" {
    typedef struct __IOHIDEvent *IOHIDEventRef;
    uint32_t IOHIDEventGetType(IOHIDEventRef event);
    float IOHIDEventGetFloatValue(IOHIDEventRef event, uint32_t field);
}

%hook IOHIDEventSystemClient
- (void)handleEvent:(IOHIDEventRef)event {
    if (IOHIDEventGetType(event) == 11) {
        // 0x0B0001 e 0x0B0002 são os códigos para X e Y relativo
        float deltaX = IOHIDEventGetFloatValue(event, 0x0B0001);
        float deltaY = IOHIDEventGetFloatValue(event, 0x0B0002);
        NSLog(@"[RawMouse] Movimento Detectado: DX:%f DY:%f", deltaX, deltaY);
    }
    %orig;
}
%end

%hook BCWindowServerPointerController
- (void)setGlobalPointerOpacity:(double)arg1 {
    %orig(0.0); // Esconde a bolinha cinza
}
%end
