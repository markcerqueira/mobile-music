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
#include "Noise.h"
#include "BiQuad.h"
#include "FileWvIn.h"

class FlareSound
{
public:
    FlareSound(float fs);
    ~FlareSound();
    
    void init();
    float tick();
    void destroy();
    
    void setFrequency(float f);
    void setGain(float g) { m_gain = g; }
    
    enum SoundMode
    {
        BLIT_MODE,
        BANDEDWG_MODE,
        WAVFILE_MODE,
        NOISE_MODE,
    };
    
    static void setGlobalSoundMode(SoundMode mode) { s_globalMode = mode; }
    void setSoundMode(SoundMode mode) { m_mode = mode; }
    
private:
    static SoundMode s_globalMode;
    
    const float m_fs;
    
    float m_gain;
    float m_freq;
    
    SoundMode m_mode;
    
    stk::BandedWG m_wg;
    stk::Blit m_blit;
    
    stk::Noise m_noise;
    stk::BiQuad m_noiseFilter;
    
    stk::FileWvIn m_wav;
};

#endif
