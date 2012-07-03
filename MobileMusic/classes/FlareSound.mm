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
    
    m_mode = BLIT_MODE;
}

FlareSound::~FlareSound()
{
    
}


void FlareSound::init()
{
    m_gain = 1;
    m_freq = 220;
    
    m_wg.setPreset(3);
    
    m_blit.setHarmonics(12);
    
    m_noise.setSeed(time(NULL));
    m_noiseFilter.setResonance(m_freq, 0.5, true);
    m_noiseFilter.setEqualGainZeroes();
}

void FlareSound::setFrequency(float f)
{
    m_freq = f;
    
    m_blit.setFrequency(m_freq);
    m_wg.noteOn(m_freq, 1.0);
    
    m_noiseFilter.setResonance(m_freq, 0.99999, true);
    m_noiseFilter.setEqualGainZeroes();
}

float FlareSound::tick()
{
    float samp = 0;
    switch(m_mode)
    {
        case BLIT_MODE:
            samp = m_gain * m_blit.tick();
            break;
        case BANDEDWG_MODE:
            break;
        case WAVFILE_MODE:
            break;
        case NOISE_MODE:
            samp = m_gain * m_noiseFilter.tick(m_noise.tick()*0.001);
            break;
    }
    
    return samp;
}


void FlareSound::destroy()
{
    
}
