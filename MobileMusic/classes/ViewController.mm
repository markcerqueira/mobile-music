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


// B-flat -- the first note in our progression
static const int g_rootNote = 46;
// our scale -- inverted 7th chord arpeggio, across 3 octaves
static const int g_scale[] =
{ 
    0,   4,  7,  9, 
    12, 16, 19, 21,
    24, 28, 31, 33,
        31, 28, 24,
    21, 19, 16, 12,
     9,  7,  4
};
// total length of the scale
static const int g_scaleLength = sizeof(g_scale)/sizeof(int);


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


@interface ViewController ()
{
    GLKMatrix4 _projectionMatrix;
    GLKMatrix4 _modelviewMatrix;
    float _rotation;
    
    std::map<UITouch *, Flare *> flares;
    
    Flare * flare1;
    
    int lastRoot;
    int scaleIndex;
    GLcolor4f currentColor;
}

@property (strong, nonatomic) EAGLContext *context;

// setup OpenGL graphics
- (void)setupGL;
// shutdown OpenGL graphics and release related resources
- (void)tearDownGL;

// called when all fingers lift off the touchscreen
// advances to the next chord and picks out a new color for new flares
- (void)advanceChord;

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
    
    // setup OpenGL
    [self setupGL];
    
    // seed random number generator
    srandom(time(NULL));
    
    lastRoot = g_rootNote;
    scaleIndex = 0;
    
    if(flare1 != NULL) { delete flare1; flare1 = NULL; }
    
    // create the initial flare
    flare1 = new Flare;
    flare1->init();
    flare1->mute(true);
    
    // "advance" the chord to make sure all parameters are in the right place
    [self advanceChord];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
    
    if(flare1 != NULL) { delete flare1; flare1 = NULL; }
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

- (void)advanceChord
{
    // choose new random color based on hue-saturation-value
    GLcolor4f hsv;
    // random hue between [0,1]
    hsv.h = ((float) random()) / INT_MAX;
    // random saturation between [0.2,0.5]
    hsv.s = 0.2 + 0.3*(((float) random()) / INT_MAX);
    // random brightness between [0.8,1.0]
    hsv.b = 0.8 + 0.2*(((float) random()) / INT_MAX);
    currentColor = hsv2rgb(hsv);
    
    // descend the root note a major third
    lastRoot -= 4;
    // but constrain it to within the octave above the initial root note
    while(lastRoot < g_rootNote)
        lastRoot += 12;
    while(lastRoot >= g_rootNote+12)
        lastRoot -= 12;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    // set projection matrix
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    _projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, 1.0/aspect, -1.0/aspect, 0.1, 100);
    
    // update touch-flares
    for(std::map<UITouch *, Flare *>::iterator i = flares.begin(); i != flares.end(); i++)
    {
        Flare * f = i->second;
        f->update(self.timeSinceLastUpdate);
    }
    
    // update the initial flare, if there is one
    if(flare1 != NULL)
        flare1->update(self.timeSinceLastUpdate);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // clear the background to black
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // set project matrix
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(_projectionMatrix.m);
    
    // set model + view matrix
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    // pull the camera back a bit
    glTranslatef(0, 0, -2);
    
    // render all active flares
    for(std::map<UITouch *, Flare *>::iterator i = flares.begin(); i != flares.end(); i++)
    {
        Flare * f = i->second;
        f->render();
    }
    
    // render the "solo" flare, if its set
    if(flare1)
        flare1->render();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        // the flare that will be associated with this touch
        Flare * f = NULL;
        
        if(flare1 != NULL)
        {
            // use the initial flare if available
            f = flare1;
            flare1->mute(false);
            flare1 = NULL;
        }
        else
        {
            // otherwise create a new flare
            f = new Flare;
            f->init();
        }

        // set location
        f->setLocation(uiview2gl([touch locationInView:self.view], self.view));
        
        // set pitch of the flare
        f->setPitch(lastRoot + g_scale[scaleIndex++ % g_scaleLength]);
        
        // set the flare's color
        f->setColor(currentColor);
        
        // link the touch -> flare
        flares[touch] = f;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        // each touch should have an associated flare, but double check
        if(flares.count(touch) == 0) continue;
        
        // get the flare for this touch
        Flare * f = flares[touch];
        // update its location
        f->setLocation(uiview2gl([touch locationInView:self.view], self.view));
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        // each touch should have an associated flare, but double check
        if(flares.count(touch) == 0) continue;
        
        // get the flare for this touch
        Flare * f = flares[touch];
        
        if(flares.size() == 1)
        {
            // this is the last flare, so leave it visible/inaudible as "flare1"
            
            // update its final location
            f->setLocation(uiview2gl([touch locationInView:self.view], self.view));
            flare1 = f;
            flare1->mute(true);
            
            // advance to the next root note/chord
            [self advanceChord];
        }
        else
        {
            // this is not the last flare, so we can simply delete it
            delete f;
            f = NULL;
        }
        
        // remove the mapping from touch -> flare
        flares.erase(touch);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // treat a touch cancellation the same as a touch end
    [self touchesEnded:touches withEvent:event];
}

@end
