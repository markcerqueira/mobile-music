//
//  GLViewController.m
//  MobileMusic2
//
//  Created by Spencer Salazar on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "GLViewController.h"
#import "Geometry.h"


//------------------------------------------------------------------------------
// name: uiview2gl
// desc: convert UIView coordinates to the OpenGL coordinate space
//------------------------------------------------------------------------------
GLvertex2f uiview2gl(CGPoint p, UIView * view)
{
    GLvertex2f v;
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    v.x = ((p.x - view.bounds.origin.x)/view.bounds.size.width)*2-1;
    v.y = (((p.y - view.bounds.origin.y)/view.bounds.size.height)*2-1)/aspect;
    return v;
}



@interface GLViewController ()

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation GLViewController

@synthesize context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)update
{

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    /*** clear ***/
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    /*** setup projection matrix ***/
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, 1.0/aspect, -1.0/aspect, -1, 100);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(projectionMatrix.m);
    
    /*** set model + view matrix ***/
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}



@end
