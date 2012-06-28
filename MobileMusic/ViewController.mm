//
//  ViewController.m
//  MobileMusic
//
//  Created by Mark on 6/20/12.
//  Copyright (c) 2012 Tronic 2012. All rights reserved.
//

#import "ViewController.h"


GLfloat gCubeVertexData[360] = 
{
    // Data layout for each line below is:
    // positionX/Y/Z,          normalX/Y/Z,         colorR/G/B/A
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,    1.0f, 0.0f, 0.5f, 1.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,    1.0f, 0.0f, 0.5f, 1.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,    1.0f, 0.0f, 0.5f, 1.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,    1.0f, 0.0f, 0.5f, 1.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,    1.0f, 0.0f, 0.5f, 1.0f,
    0.5f, 0.5f, 0.5f,          1.0f, 0.0f, 0.0f,    1.0f, 0.0f, 0.5f, 1.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,    0.5f, 1.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,    0.5f, 1.0f, 0.0f, 1.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,    0.5f, 1.0f, 0.0f, 1.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,    0.5f, 1.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,    0.5f, 1.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,    0.5f, 1.0f, 0.0f, 1.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,    0.0f, 0.5f, 1.0f, 1.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,    0.0f, 0.5f, 1.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,    0.0f, 0.5f, 1.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,    0.0f, 0.5f, 1.0f, 1.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,    0.0f, 0.5f, 1.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,    0.0f, 0.5f, 1.0f, 1.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,    0.5f, 0.0f, 1.0f, 1.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,    0.5f, 0.0f, 1.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,    0.5f, 0.0f, 1.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,    0.5f, 0.0f, 1.0f, 1.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,    0.5f, 0.0f, 1.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,    0.5f, 0.0f, 1.0f, 1.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,    1.0f, 0.5f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    1.0f, 0.5f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    1.0f, 0.5f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    1.0f, 0.5f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    1.0f, 0.5f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,    1.0f, 0.5f, 0.0f, 1.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,    0.0f, 1.0f, 0.5f, 1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,    0.0f, 1.0f, 0.5f, 1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,    0.0f, 1.0f, 0.5f, 1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,    0.0f, 1.0f, 0.5f, 1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,    0.0f, 1.0f, 0.5f, 1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f,     0.0f, 1.0f, 0.5f, 1.0f,
};

@interface ViewController () {
    
    GLKMatrix4 _projectionMatrix;
    GLKMatrix4 _modelviewMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ViewController

@synthesize context = _context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
        
    glEnable(GL_DEPTH_TEST);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    
    // Compute the model view matrix for the object rendered with GLKit
    _modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    _modelviewMatrix = GLKMatrix4Rotate(_modelviewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    _modelviewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, _modelviewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(_projectionMatrix.m);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(_modelviewMatrix.m);
    
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glVertexPointer(3, GL_FLOAT, 10*sizeof(float), gCubeVertexData);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    glNormalPointer(GL_FLOAT, 10*sizeof(float), gCubeVertexData+3);
    glEnableClientState(GL_NORMAL_ARRAY);
    
    glColorPointer(4, GL_FLOAT, 10*sizeof(float), gCubeVertexData+6);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

@end
