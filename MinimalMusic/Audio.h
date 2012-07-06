//
//  Audio.h
//  MobileMusic2
//
//  Created by Spencer Salazar on 7/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#ifndef MobileMusic2_Audio_h
#define MobileMusic2_Audio_h


#define SAMPLERATE (44100)


class Audio
{
public:
    void start();
    void stop();
    
    void audio_callback(float * buffer, int frames);
    
    void keyDown();
    void keyUp();
    
private:
    
    float m_freq;
    float m_phase;
    float m_gain;
    
    float m_modFreq;
    float m_modPhase;
    float m_modGain;
};


#endif
