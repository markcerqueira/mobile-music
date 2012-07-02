//
//  ViewController.m
//  MobileMusic
//
//  Created by Mark on 6/20/12.
//  Copyright (c) 2012 Tronic 2012. All rights reserved.
//

#import "ViewController.h"
#import "Flare.h"
#import <map>


GLvertex2f uiview2gl(CGPoint p, UIView * view)
{
    GLvertex2f v;
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    v.x = ((p.x - view.bounds.origin.x)/view.bounds.size.width)*2-1;
    v.y = (((p.y - view.bounds.origin.y)/view.bounds.size.height)*2-1)/aspect;
    return v;
}


@interface ViewController ()
{
    GLKMatrix4 _projectionMatrix;
    GLKMatrix4 _modelviewMatrix;
    float _rotation;
    
    std::map<UITouch *, Flare *> flares;
    
    Flare * flare1;
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
    
    flare1 = new Flare;
    flare1->init();
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
//    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    _projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, 1.0/aspect, -1.0/aspect, 0.1, 100);
    
    for(std::map<UITouch *, Flare *>::iterator i = flares.begin(); i != flares.end(); i++)
    {
        Flare * f = i->second;
        f->update(self.timeSinceLastUpdate);
    }
    
    if(flare1)
        flare1->update(self.timeSinceLastUpdate);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(_projectionMatrix.m);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
        
    glTranslatef(0, 0, -2);
    
    for(std::map<UITouch *, Flare *>::iterator i = flares.begin(); i != flares.end(); i++)
    {
        Flare * f = i->second;
        f->render();
    }
    
    if(flare1)
        flare1->render();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        Flare * f = NULL;
        if(flare1 == NULL)
        {
            f = new Flare;
            f->init();
        }
        else
        {
            f = flare1;
            flare1 = NULL;
        }
        
        f->setLocation(uiview2gl([touch locationInView:self.view], self.view));
        
        flares[touch] = f;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        if(flares.count(touch) == 0) continue;
        
        Flare * f = flares[touch];
        f->setLocation(uiview2gl([touch locationInView:self.view], self.view));
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        if(flares.count(touch) == 0) continue;
        
        Flare * f = flares[touch];
        
        if(flares.size() == 1) // last item
        {
            assert(flare1 == NULL);
            f->setLocation(uiview2gl([touch locationInView:self.view], self.view));
            flare1 = f;
        }
        else
        {
            delete f;
            f = NULL;
        }
        
        flares.erase(touch);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end
