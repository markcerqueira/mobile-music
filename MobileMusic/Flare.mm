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


GLuint Flare::tex = 0;

Flare::Flare()
{
    t = 0;
    tex = 0;
    square[0] = GLgeoprimf();
    square[1] = GLgeoprimf();
    square[2] = GLgeoprimf();
    square[3] = GLgeoprimf();
    
    m_pitch = 60;
    m_gain = 1;
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
    
    // strip of triangles to form a square
    square[0].vertex = GLvertex3f(-r, -r, 0);
    square[1].vertex = GLvertex3f(r, -r, 0);
    square[2].vertex = GLvertex3f(-r, r, 0);
    square[3].vertex = GLvertex3f(r, r, 0);
    
    GLvertex3f n = GLvertex3f(0, 0, -1);
    square[0].normal = square[1].normal = square[2].normal = square[3].normal = n;
    
    square[0].texcoord = GLvertex2f(0, 0);
    square[1].texcoord = GLvertex2f(1, 0);
    square[2].texcoord = GLvertex2f(0, 1);
    square[3].texcoord = GLvertex2f(1, 1);
    
    GLcolor4f c = GLcolor4f(0.8, 0.75, 0.16, 1.0);
    
    square[0].color = square[1].color = square[2].color = square[3].color = c;
    
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
    
    if(fs != NULL)
    {
        float sign = 1;
        if(loc.y == 0) sign = 1;
        else sign = loc.y/fabs(loc.y);
        fs->setFrequency(mtof(m_pitch) + sign*(2-loc.magnitudeSquared())*2);
    }
}


void Flare::setPitch(float p)
{
    m_pitch = p;
    
    if(fs != NULL)
    {
        float sign = 1;
        if(loc.y == 0) sign = 1;
        else sign = loc.y/fabs(loc.y);
        fs->setFrequency(mtof(m_pitch) + sign*(2-loc.magnitudeSquared())*2);
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
    
    float f_scale = 1.0/4.0;
    scale = 1 + 0.16*sinf(2*M_PI*t*f_scale);
    
    float f_alpha = f_scale;
    GLcolor4f c = square[0].color;
    c.a = 1 + 0.1*sinf(2*M_PI*t*f_alpha);
    
    square[0].color = square[1].color = square[2].color = square[3].color = c;
}


void Flare::render()
{
    glPushMatrix();
    
    glTranslatef(loc.x, loc.y, loc.z);
    glScalef(scale, scale, scale);
    
    glEnable(GL_BLEND);
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, tex);
    
    glVertexPointer(3, GL_FLOAT, sizeof(GLgeoprimf), &square[0].vertex);
    glEnableClientState(GL_VERTEX_ARRAY);
    glNormalPointer(GL_FLOAT, sizeof(GLgeoprimf), &square[0].normal);
    glEnableClientState(GL_NORMAL_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, sizeof(GLgeoprimf), &square[0].texcoord);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glColorPointer(4, GL_FLOAT, sizeof(GLgeoprimf), &square[0].color);
    glEnableClientState(GL_COLOR_ARRAY);
    
    // drawing twice makes a nice over-exposed effect
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glPopMatrix();
}

void Flare::destroy()
{
//    if(tex) { glDeleteTextures(1, &tex); tex = 0; }
    MMAudio::instance()->remove(fs);
    fs = NULL; // MMAudio is responsible for freeing fs's memory
}


void Flare::fadeOut()
{
    
}

