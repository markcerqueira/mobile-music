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

class Flare
{
public:
    Flare();
    ~Flare();
    
    void init();
    void update(float dt);
    void render();
    void destroy();
    
protected:
    GLuint tex;
    GLgeoprimf square[4];
    float scale;
    float t;
};


#endif
