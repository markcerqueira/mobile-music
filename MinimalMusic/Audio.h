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
#include "FileWvIn.h"
#include "FileWvOut.h"
#include "CircularBuffer.h"
#include <list>


#define SAMPLERATE (44100)


struct MarioTouchSound
{
    MarioTouchSound();
    void setFreq(float f);
    void tick(float * buffer, int frames);
    
    float m_freq;
    float m_modGain;
    float m_lfoFreq;
    
    float m_phase;
    float m_gain;
    
    float m_modFreq;
    float m_modPhase;
    
    float m_lfoPhase;
    float m_lfoGain;
    
    stk::ADSR m_adsr;
    Butterworth2Filter m_filter;
};


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
    
    CircularBuffer<MarioTouchSound *> * m_addList;
    CircularBuffer<MarioTouchSound *> * m_removeList;
    
private:
    std::list<MarioTouchSound *> m_sounds;
    
    
    float m_phase;
    float m_gain;
    
    float m_modFreq;
    float m_modPhase;
    
    float m_lfoPhase;
    float m_lfoGain;
    
    stk::ADSR m_adsr;
    Butterworth2Filter m_filter;
    
    stk::FileWvIn m_fileIn;
    bool m_isPlaying;
    
    stk::FileWvOut m_fileOut;
    CircularBuffer<float> * m_recordBuffer;
    bool m_isRecording;
};


#endif
