//
//  ViewController.m
//  MobileMusic
//
//  Created by Mark on 6/20/12.
//  Copyright (c) 2012 Tronic 2012. All rights reserved.
//

#import "ViewController.h"
#import "Flare.h"
#import "HSV.h"
#import <map>


static const int g_rootNote = 46;
static int g_lastRoot = g_rootNote;
static const int g_scale[] =
{ 
    0,   4,  7,  9, 
    12, 16, 19, 21,
    24, 28, 31, 33,
        31, 28, 24,
    21, 19, 16, 12,
     9,  7,  4
};
static const int g_scaleLength = sizeof(g_scale)/sizeof(int);
static int g_scaleIndex = 0;


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
    
    GLcolor4f currentColor;
}

@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

- (void)allTouchesLeft;

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
    
    srandom(time(NULL));
    
    flare1 = new Flare;
    flare1->init();
    flare1->mute(true);
    
    [self allTouchesLeft];
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
            flare1->mute(false);
            flare1 = NULL;
        }
        
        f->setLocation(uiview2gl([touch locationInView:self.view], self.view));
        
        f->setPitch(g_lastRoot + g_scale[g_scaleIndex++ % g_scaleLength]);
        
        f->setColor(currentColor);
        
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
            flare1->mute(true);
            
            [self allTouchesLeft];
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

- (void)allTouchesLeft
{
    GLcolor4f hsv;
    hsv.h = ((float) random()) / INT_MAX;
    hsv.s = 0.2 + 0.3*(((float) random()) / INT_MAX);
    hsv.b = 0.8 + 0.2*(((float) random()) / INT_MAX);
    currentColor = hsv2rgb(hsv);
    
    g_lastRoot -= 4;
    while(g_lastRoot < g_rootNote)
        g_lastRoot += 12;
    while(g_lastRoot >= g_rootNote+12)
        g_lastRoot -= 12;
}

@end
