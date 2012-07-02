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
#include "Blit.h"

class FlareSound
{
public:
    FlareSound(float fs);
    ~FlareSound();
    
    void init();
    float tick();
    void destroy();
    
    void setFrequency(float f) { m_freq = f; m_blit.setFrequency(f); m_wg.noteOn(f, 1.0); }
    void setGain(float g) { m_gain = g; }
    
private:
    const float m_fs;
    
    float m_gain;
    float m_freq;
    float m_modulator_phase;
    float m_carrier_phase;
    
    stk::BandedWG m_wg;
    stk::Blit m_blit;
};

#endif
