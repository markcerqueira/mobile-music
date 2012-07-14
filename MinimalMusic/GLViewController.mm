//
//  GLViewController.m
//  MobileMusic2
//
//  Created by Spencer Salazar on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "GLViewController.h"
#import "Geometry.h"
#import "Audio.h"
#import "Texture.h"
#import <map>
#import "mtof.h"


struct MarioTouch
{
    GLuint tex;
    GLvertex2f location;
    
    MarioTouchSound * sound;
};


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
{
    GLvertex2f m_touchLocation;
    Audio m_audio;
    
    GLuint tex;
    
    std::map<UITouch *,MarioTouch *> m_touches;
}

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
    self.view.multipleTouchEnabled = YES;
    
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_TEXTURE_2D);
    tex = loadTexture(@"flare.png");
    
    m_audio.start();
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

//    glTranslatef(m_touchLocation.x, m_touchLocation.y, 0);
//    glRotatef(1, 0, 0, 1);
//    glScalef(0.25, 0.25, 0.25);
    
    float r = 0.5;
    GLvertex3f square[6];
    
    square[0] = GLvertex3f(-r, -r, 0);
    square[1] = GLvertex3f( r, -r, 0);
    square[2] = GLvertex3f(-r,  r, 0);
    
    square[3] = GLvertex3f( r, -r, 0);
    square[4] = GLvertex3f(-r,  r, 0);
    square[5] = GLvertex3f( r,  r, 0);
    
    glVertexPointer(3, GL_FLOAT, 0, square);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    GLcolor4f c = GLcolor4f(0.5, 0.5, 0, 1.0);
    GLcolor4f squareColor[6];
    squareColor[0] = squareColor[1] = squareColor[2] = c;
    squareColor[3] = squareColor[4] = squareColor[5] = c;
    
    GLvertex2f squareTexCoords[6];
    squareTexCoords[0] = GLvertex2f(0, 0);
    squareTexCoords[1] = GLvertex2f(1, 0);
    squareTexCoords[2] = GLvertex2f(0, 1);
    
    squareTexCoords[3] = GLvertex2f(1, 0);
    squareTexCoords[4] = GLvertex2f(0, 1);
    squareTexCoords[5] = GLvertex2f(1, 1);
    
    glColorPointer(4, GL_FLOAT, 0, squareColor);
    glEnableClientState(GL_COLOR_ARRAY);
    //glDisableClientState(GL_COLOR_ARRAY);
    
    glTexCoordPointer(2, GL_FLOAT, 0, squareTexCoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    // normal alpha blend
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // additive blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
    for(std::map<UITouch *,MarioTouch *>::iterator i = m_touches.begin();
        i != m_touches.end(); i++)
    {
        MarioTouch * marioTouch = i->second;
        
        glBindTexture(GL_TEXTURE_2D, marioTouch->tex);
        
        glPushMatrix();
        
        glTranslatef(marioTouch->location.x, marioTouch->location.y, 0);
        
        glDrawArrays(GL_TRIANGLES, 0, 6);
        glDrawArrays(GL_TRIANGLES, 0, 6);
        
        glPopMatrix();
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        CGPoint p = [touch locationInView:self.view];
        GLvertex2f v = uiview2gl(p, self.view);
        m_touchLocation = v;
        
        MarioTouch * marioTouch = new MarioTouch;
        marioTouch->tex = tex;
        marioTouch->location = v;
        
        m_touches[touch] = marioTouch;
        
        MarioTouchSound * touchSound = new MarioTouchSound;
        marioTouch->sound = touchSound;
        
        float scale[] = {0, 4, 7, 11};
        
        float note = 60 + scale[arc4random()%4]+12*arc4random()%3;
        touchSound->setFreq(mtof(note));
        
        touchSound->m_gain = 0.1;
        touchSound->m_modGain = 600+v.x*400;
        touchSound->m_lfoFreq = 2*powf(10,v.y);
        touchSound->m_adsr.keyOn();
        
        m_audio.m_addList->put(touchSound);
        
        m_audio.keyDown();
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        CGPoint p = [touch locationInView:self.view];
        GLvertex2f v = uiview2gl(p, self.view);
        m_touchLocation = v;
        
        MarioTouch * marioTouch = m_touches[touch];
        
        marioTouch->location = v;
        
        MarioTouchSound * touchSound = marioTouch->sound;
        
        touchSound->m_modGain = 600+v.x*400;
        touchSound->m_lfoFreq = 2*powf(10,v.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        CGPoint p = [touch locationInView:self.view];
        GLvertex2f v = uiview2gl(p, self.view);
        m_touchLocation = v;
        
        MarioTouch * marioTouch = m_touches[touch];
        m_audio.m_removeList->put(marioTouch->sound);
        
        m_touches.erase(touch);
        
        m_audio.keyUp();
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}



@end
