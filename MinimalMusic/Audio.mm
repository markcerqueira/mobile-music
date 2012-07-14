//
//  Audio.mm
//  MobileMusic2
//
//  Created by Spencer Salazar on 7/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#include <iostream>
#include "Audio.h"
#include "mo_audio.h"
#include "Filepaths.h"


float sineWave(float phase)
{
    return sinf(2*M_PI*phase);
}

float sawtoothWave(float phase)
{
    return 2*phase-1;
}

float triangleWave(float phase)
{
    if(phase < 0.5)
        return 2*(2*phase)-1;
    else
        return -1*(2*(2*(phase-0.5))-1);
}

float squareWave(float phase)
{
    if(phase < 0.5)
        return 1;
    else
        return -1;
}



MarioTouchSound::MarioTouchSound()
{
    m_freq = 220;
    m_phase = 0;
    m_gain = 1;
    
    m_modFreq = m_freq*2;
    m_modPhase = 0;
    // try different values for modGain!
    m_modGain = 1000;
    
    m_lfoFreq = 0.125;
    m_lfoPhase = 0;
    m_lfoGain = 1;
    
    // 
    m_adsr.setAllTimes(0.02, 0.01, 0.5, 0.2);
    
    m_filter.set_sample_rate(SAMPLERATE);
    m_filter.set_rlpf(m_freq, 10);
}

void MarioTouchSound::setFreq(float f)
{
    m_freq = f;
    m_modFreq = m_freq*4;
}

void MarioTouchSound::tick(float * buffer, int frames)
{
    float lfo = sineWave(m_lfoPhase) * m_lfoGain;
    m_filter.set_rlpf(m_freq*4+100*lfo, 4);
    
    m_lfoPhase += m_lfoFreq*frames/SAMPLERATE;
    
    for(int i = 0; i < frames; i++)
    {
        float mod = sineWave(m_modPhase);
        mod = mod * m_modGain;
        
        m_modPhase += m_modFreq/SAMPLERATE;
        if(m_modPhase > 1) m_modPhase -= 1;

        float sample = 0;
        
        sample = squareWave(m_phase);
        
        m_phase += (m_freq+mod)/SAMPLERATE;
        if(m_phase > 1) m_phase -= 1;
        
        sample = m_filter.tick_rlpf(sample);
        
        sample = sample * m_gain * m_adsr.tick();
        
        // interleaved stereo operation
        buffer[i*2] += sample;
        buffer[i*2+1] += sample;
    }
}



void g_audio_callback(Float32 * buffer, UInt32 numFrames, void * userData)
{
    @autoreleasepool 
    {
        Audio * audio = (Audio *) userData;
        audio->audio_callback(buffer, numFrames);
    }
}


void Audio::start()
{
    m_recordBuffer = new CircularBuffer<float>(256*10);
    
    MoAudio::init(SAMPLERATE, 256, 2);
    MoAudio::start(g_audio_callback, this);
    
    m_freq = 220;
    m_phase = 0;
    m_gain = 1;
    
    m_modFreq = m_freq*2;
    m_modPhase = 0;
    // try different values for modGain!
    m_modGain = 1000;
    
    m_lfoFreq = 0.125;
    m_lfoPhase = 0;
    m_lfoGain = 1;
    
    // 
    m_adsr.setAllTimes(0.02, 0.01, 0.5, 0.2);
    
    m_filter.set_sample_rate(SAMPLERATE);
    m_filter.set_rlpf(m_freq, 10);
    
    m_addList = new CircularBuffer<MarioTouchSound *>(20);
    m_removeList = new CircularBuffer<MarioTouchSound *>(20);
}

void Audio::stop()
{
    
}


void Audio::keyDown()
{
    m_adsr.keyOn();
    
    std::string filepath = stlDocumentsFilepath("tmp.wav");
    m_fileOut.openFile(filepath, 1, stk::FileWrite::FILE_WAV, stk::Stk::STK_FLOAT32);
    
    m_isRecording = true;
    m_isPlaying = false;
}

void Audio::keyUp()
{
    m_adsr.keyOff();
    
    m_fileOut.closeFile();
    
    m_isRecording = false;
    m_isPlaying = true;
}

void Audio::audio_callback(float * buffer, int frames)
{
    MarioTouchSound * touchSound;
    while(m_addList->get(touchSound))
        m_sounds.push_back(touchSound);
    
    while(m_removeList->get(touchSound))
    {
        m_sounds.remove(touchSound);
        delete touchSound;
    }
    
    memset(buffer, 0, sizeof(float)*frames*2);
    
    for(std::list<MarioTouchSound *>::iterator i = m_sounds.begin();
        i != m_sounds.end(); i++)
    {
        MarioTouchSound * touchSound = *i;
        touchSound->tick(buffer, frames);
    }
    
//    float lfo = sineWave(m_lfoPhase) * m_lfoGain;
//    m_filter.set_rlpf(m_freq+100*lfo, 4);
//    
//    m_lfoPhase += m_lfoFreq*frames/SAMPLERATE;
//    
//    for(int i = 0; i < frames; i++)
//    {
//        float mod = triangleWave(m_modPhase);
//        mod = mod * m_modGain;
//        
//        m_modPhase += m_modFreq/SAMPLERATE;
//        if(m_modPhase > 1) m_modPhase -= 1;
//
//        float sample = 0;
//        
//        sample = squareWave(m_phase);
//        
//        m_phase += (m_freq+mod)/SAMPLERATE;
//        if(m_phase > 1) m_phase -= 1;
//        
//        sample = m_filter.tick_rlpf(sample);
//        
//        sample = sample * m_gain * m_adsr.tick();
//        
//        // interleaved stereo operation
//        buffer[i*2] = sample;
//        buffer[i*2+1] = sample;
//    }
    
//    if(m_isPlaying && !m_fileIn.isOpen())
//    {
//        // open the file
//        std::string filepath = stlDocumentsFilepath("tmp.wav");
//        m_fileIn.openFile(filepath);
//    }
//    else if(!m_isPlaying && m_fileIn.isOpen())
//    {
//        // close the file
//        m_fileIn.closeFile();
//    }
//    else if(m_fileIn.isFinished())
//    {
//        // close the file
//        m_fileIn.closeFile();
//        m_isPlaying = false;
//    }
//    
//    for(int i = 0; i < frames; i++)
//    {
//        float leftInput = buffer[i*2];
//        float rightInput = buffer[i*2+1];
//        
//        float sample = 0;
//        
//        if(m_isPlaying)
//            sample = m_fileIn.tick();
//        
//        if(m_isRecording)
//            m_recordBuffer->put(leftInput);
//        
//        buffer[i*2] = sample;
//        buffer[i*2+1] = sample;
//    }
//    
//    if(m_isRecording)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(m_isRecording)
//            {
//                float sample;
//                while(m_recordBuffer->get(sample))
//                    m_fileOut.tick(sample);
//            }
//        });
//    }
}

