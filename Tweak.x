#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Definições manuais para o robô não se perder
extern "C" {
    typedef struct __IOHIDEvent *IOHIDEventRef;
    uint32_t IOHIDEventGetType(IOHIDEventRef event);
    float IOHIDEventGetFloatValue(IOHIDEventRef event, uint32_t field);
    
    // Códigos específicos do mouse no iPad
    #define kIOHIDEventTypePointer 11
    #define kIOHIDEventFieldPointerX 0x0B0001
    #define kIOHIDEventFieldPointerY 0x0B0002
}

%hook IOHIDEventSystemClient
- (void)handleEvent:(IOHIDEventRef)event {
    if (event != NULL && IOHIDEventGetType(event) == kIOHIDEventTypePointer) {
        float dx = IOHIDEventGetFloatValue(event, kIOHIDEventFieldPointerX);
        float dy = IOHIDEventGetFloatValue(event, kIOHIDEventFieldPointerY);
        
        // Log que aparecerá no console do iPad
        NSLog(@"[RawMouse] Movimento Detectado: X=%f Y=%f", dx, dy);
    }
    %orig;
}
%end

%hook BCWindowServerPointerController
- (void)setGlobalPointerOpacity:(double)arg1 {
    %orig(0.0); // Deixa a bolinha nativa invisível
}
%end
