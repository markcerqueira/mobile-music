//
//  Audio.h
//  MobileMusic2
//
//  Created by Spencer Salazar on 7/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#ifndef MobileMusic2_Audio_h
#define MobileMusic2_Audio_h


#include "ADSR.h"
#include "SPFilter.h"


#define SAMPLERATE (44100)


class Audio
{
public:
    void start();
    void stop();
    
    void audio_callback(float * buffer, int frames);
    
    void keyDown();
    void keyUp();

    float m_freq;
    float m_modGain;
    float m_lfoFreq;
    
private:
    
    float m_phase;
    float m_gain;
    
    float m_modFreq;
    float m_modPhase;
    
    float m_lfoPhase;
    float m_lfoGain;
    
    stk::ADSR m_adsr;
    Butterworth2Filter m_filter;
};


#endif
