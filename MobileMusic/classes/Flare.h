//
//  Flare.h
//  MobileMusic
//
//  Created by Spencer Salazar on 6/28/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#ifndef MobileMusic_Flare_h
#define MobileMusic_Flare_h

#include "Geometry.h"

class FlareSound;

class Flare
{
public:
    Flare();
    ~Flare();
    
    void init();
    void update(float dt);
    void render();
    void destroy();
    
    void setColor(GLcolor4f c) { m_color = c; }
    void setLocation(GLvertex3f loc);
    void setPitch(float p);
    void mute(bool m);
    
    void fadeOut();
    
protected:
    static GLuint tex;
    GLgeoprimf square[4];
    
    GLcolor4f m_color;
    GLvertex3f loc;
    float scale;
    float t;
    
    FlareSound * fs;
    float m_pitch;
    float m_gain;
};


#endif
