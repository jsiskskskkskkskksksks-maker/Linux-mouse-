#import "RootViewController.h"

// Definições para o mouse funcionar
typedef struct __IOHIDEvent *IOHIDEventRef;
extern uint32_t IOHIDEventGetType(IOHIDEventRef event);
extern float IOHIDEventGetFloatValue(IOHIDEventRef event, uint32_t field);

@implementation RootViewController {
    UIImageView *_cursorView; // A seta do Mac/Linux
    CGPoint _currentPos;      // Posição atual do mouse
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 1. Criar a seta (Cursor)
    _cursorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    // Você pode usar um emoji de seta ou carregar uma imagem depois
    _cursorView.image = [self drawCursorImage]; 
    [self.view addSubview:_cursorView];
    
    _currentPos = self.view.center;
    _cursorView.center = _currentPos;
    
    // 2. Esconder a bolinha nativa do iPad
    // Nota: Isso funciona dentro do seu app
    [self setNeedsUpdateOfPrefersPointerLocked:YES];
}

// Desenha uma setinha simples via código para não precisar de arquivo de imagem
- (UIImage *)drawCursorImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 30), NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(20, 20)];
    [path addLineToPoint:CGPointMake(10, 20)];
    [path addLineToPoint:CGPointMake(0, 30)];
    [path closePath];
    [[UIColor whiteColor] setFill];
    [path fill];
    [[UIColor blackColor] setStroke];
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 3. O "Coração": Receber o movimento do mouse de PC (Raw Input)
- (void)handleHIDEvent:(IOHIDEventRef)event {
    if (IOHIDEventGetType(event) == 11) { // 11 = Movimento de Mouse
        float dx = IOHIDEventGetFloatValue(event, 0x0B0001);
        float dy = IOHIDEventGetFloatValue(event, 0x0B0002);
        
        // Sensibilidade (ajuste o 1.5 para ficar mais rápido ou devagar)
        _currentPos.x += dx * 1.5;
        _currentPos.y += dy * 1.5;
        
        // Impedir a seta de sair da tela
        if (_currentPos.x < 0) _currentPos.x = 0;
        if (_currentPos.y < 0) _currentPos.y = 0;
        if (_currentPos.x > self.view.bounds.size.width) _currentPos.x = self.view.bounds.size.width;
        if (_currentPos.y > self.view.bounds.size.height) _currentPos.y = self.view.bounds.size.height;
        
        // Atualiza a posição da seta na tela
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_cursorView.center = self->_currentPos;
        });
    }
}

// Impede a bolinha de aparecer
- (BOOL)prefersPointerLocked {
    return YES;
}

@end
