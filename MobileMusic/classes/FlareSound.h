//
//  FlareSound.h
//  MobileMusic
//
//  Created by Spencer Salazar on 6/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#ifndef MobileMusic_FlareSound_h
#define MobileMusic_FlareSound_h

#include "BandedWG.h"

class FlareSound
{
public:
    FlareSound(float fs);
    ~FlareSound();
    
    void init();
    float tick();
    void destroy();
    
private:
    const float m_fs;
    float m_freq;
    
    stk::BandedWG m_wg;
};

#endif
