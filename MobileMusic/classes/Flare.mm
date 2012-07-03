//
//  Flare.mm
//  MobileMusic
//
//  Created by Spencer Salazar on 6/28/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Flare.h"
#import "Geometry.h"
#import "Texture.h"
#import "FlareSound.h"
#import "MMAudio.h"
#import "mtof.h"


float Flare::s_breathingRate = 1.0/4.0;
GLuint Flare::tex = 0;

Flare::Flare()
{
    t = 0;
    tex = 0;
//    square[0] = GLgeoprimf();
//    square[1] = GLgeoprimf();
//    square[2] = GLgeoprimf();
//    square[3] = GLgeoprimf();
    
    square2[0] = GLtrif();
    square2[1] = GLtrif();
    
    m_pitch = 60;
    m_gain = 1;
    m_breathPhase = 0;
}

Flare::~Flare()
{
    this->destroy();
}

void Flare::init()
{
    t = 0;
    
    if(tex == 0)
    {
        glEnable(GL_TEXTURE_2D);
        tex = loadTexture(@"flare.png");
    }
    
    float r = 0.5;
    
    // two triangles to form a square
    // vertices of each triangle
    square2[0].a.vertex = GLvertex3f(-r, -r, 0);
    square2[0].b.vertex = GLvertex3f(r, -r, 0);
    square2[0].c.vertex = GLvertex3f(-r, r, 0);
    
    square2[1].a.vertex = GLvertex3f(r, -r, 0);
    square2[1].b.vertex = GLvertex3f(-r, r, 0);
    square2[1].c.vertex = GLvertex3f(r, r, 0);
    
    // normal coordinates -- used for lighting calculations
    GLvertex3f n = GLvertex3f(0, 0, -1);
    square2[0].a.normal = square2[0].b.normal = square2[0].c.normal = n;
    square2[1].a.normal = square2[1].b.normal = square2[1].c.normal = n;
    
    // coordinates for texture mapping
    square2[0].a.texcoord = GLvertex2f(0, 0);
    square2[0].b.texcoord = GLvertex2f(1, 0);
    square2[0].c.texcoord = GLvertex2f(0, 1);

    square2[1].a.texcoord = GLvertex2f(1, 0);
    square2[1].b.texcoord = GLvertex2f(0, 1);
    square2[1].c.texcoord = GLvertex2f(1, 1);
    
    // color for each vertex
    GLcolor4f c = GLcolor4f(0.8, 0.75, 0.16, 1.0);
    square2[0].a.color = square2[0].b.color = square2[0].c.color = c;
    square2[1].a.color = square2[1].b.color = square2[1].c.color = c;
    
    loc = GLvertex2f(0, 0);
    
    // setup audio
    fs = new FlareSound(MOBILEMUSIC_SRATE);
    m_pitch = 60;
    m_gain = 1;
    
    fs->init();
    fs->setFrequency(mtof(m_pitch));
    
    MMAudio::instance()->add(fs);
}

void Flare::setLocation(GLvertex3f loc)
{
    this->loc = loc;
}


void Flare::setPitch(float p)
{
    m_pitch = p;
    
    if(fs != NULL)
    {
        fs->setFrequency(mtof(m_pitch));
    }
}


void Flare::mute(bool m)
{
    if(m)
        m_gain = 0;
    else
        m_gain = 1;
    
    if(fs != NULL)
        fs->setGain(m_gain);
}

void Flare::update(float dt)
{
    t += dt;
    
    scale = 1 + 0.16*sinf(2*M_PI*m_breathPhase);
    
    GLcolor4f c = m_color;
    c.a = 1 + 0.1*sinf(2*M_PI*m_breathPhase);
    
    m_breathPhase += dt*s_breathingRate;
    if(m_breathPhase > 1)
        m_breathPhase -= 1;
    
    square2[0].a.color = square2[0].b.color = square2[0].c.color = c;
    square2[1].a.color = square2[1].b.color = square2[1].c.color = c;
}


void Flare::render()
{
    glPushMatrix();
    
    // move to position
    glTranslatef(loc.x, loc.y, loc.z);
    // scale
    glScalef(scale, scale, scale);
    
    // enable additive blending
    glEnable(GL_BLEND);
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
    // enable texturing
    glEnable(GL_TEXTURE_2D);
    // specifying texture to use
    glBindTexture(GL_TEXTURE_2D, tex);
    
    // supply flare vertices
    glVertexPointer(3, GL_FLOAT, sizeof(GLgeoprimf), &square2[0].a.vertex);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    // supply flare normal coordinates
    glNormalPointer(GL_FLOAT, sizeof(GLgeoprimf), &square2[0].a.normal);
    glEnableClientState(GL_NORMAL_ARRAY);
    
    // supply square texture coordinates
    glTexCoordPointer(2, GL_FLOAT, sizeof(GLgeoprimf), &square2[0].a.texcoord);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // supply square color values
    glColorPointer(4, GL_FLOAT, sizeof(GLgeoprimf), &square2[0].a.color);
    glEnableClientState(GL_COLOR_ARRAY);
    
    // with additive blending, drawing twice makes a nice over-exposed effect
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    glPopMatrix();
}

void Flare::destroy()
{
//    if(tex) { glDeleteTextures(1, &tex); tex = 0; }
    MMAudio::instance()->remove(fs);
    fs = NULL; // MMAudio is responsible for freeing fs's memory
}


