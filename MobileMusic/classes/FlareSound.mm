//
//  FlareSound.mm
//  MobileMusic
//
//  Created by Spencer Salazar on 6/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#include "FlareSound.h"


FlareSound::FlareSound(float fs) :
m_fs(fs)
{
    m_gain = 0;
    m_freq = 220;
    m_carrier_phase = 0;
    m_modulator_phase = 0;
}

FlareSound::~FlareSound()
{
    
}


void FlareSound::init()
{
    m_gain = 1;
    m_freq = 220;
    m_carrier_phase = 0;
    m_modulator_phase = 0;
}


float FlareSound::tick()
{
    float mod_gain = 1;
    float mod_freq = m_freq;
    
//    float modulator = mod_gain * sinf(2.0f*M_PI*m_modulator_phase);
//    float samp = m_gain * sinf(2.0f*M_PI*(m_carrier_phase+modulator));
    
    float samp = m_gain * sinf(2.0f*M_PI*m_carrier_phase);
    
    m_modulator_phase += mod_freq/m_fs;
    while(m_modulator_phase > 1)
        m_modulator_phase -= 1;
    
    m_carrier_phase += m_freq/m_fs;
    while(m_carrier_phase > 1)
        m_carrier_phase -= 1;
    
    return samp;
}


void FlareSound::destroy()
{
    
}
