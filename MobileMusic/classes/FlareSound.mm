//
//  FlareSound.mm
//  MobileMusic
//
//  Created by Spencer Salazar on 6/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#include "FlareSound.h"
#include "mtof.h"


FlareSound::FlareSound(float fs) :
m_fs(fs)
{
    m_gain = 0;
    m_freq = 220;
    
    m_mode = WAVFILE_MODE;
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
    
    std::string filepath = [[[NSBundle mainBundle] pathForResource:@"spencer-ahh.wav" ofType:@""] UTF8String];
    m_wav.openFile(filepath);
}

void FlareSound::setFrequency(float f)
{
    m_freq = f;
    
    m_blit.setFrequency(m_freq);
    
    m_wg.noteOn(m_freq, 1.0);
    
    m_noiseFilter.setResonance(m_freq, 0.99999, true);
    m_noiseFilter.setEqualGainZeroes();
    
    float base = mtof(56);
    m_wav.setRate(m_freq/base);
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
            samp = m_gain * m_wg.tick();
            break;
        case WAVFILE_MODE:
            samp = m_gain * m_wav.tick() * 0.1;
            if(m_wav.isFinished()) m_wav.reset();
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
