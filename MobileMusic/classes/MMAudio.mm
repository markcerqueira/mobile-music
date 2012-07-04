//
//  MMAudio.m
//  MobileMusic
//
//  Created by Spencer Salazar on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "MMAudio.h"
#import "mo_audio.h"
#import "FlareSound.h"


void audio_callback(Float32 * buffer, UInt32 numFrames, void * userData)
{
    MMAudio * mmaudio = (MMAudio *) userData;
    
    mmaudio->audio_callback(buffer, numFrames);
}

MMAudio * g_mmaudio = NULL;

MMAudio * MMAudio::instance()
{
    if(g_mmaudio == NULL)
        g_mmaudio = new MMAudio;
    return g_mmaudio;
}

MMAudio::MMAudio() :
addList(CircularBuffer<FlareSound *>(20)),
removeList(CircularBuffer<FlareSound *>(20))
{
    stk::Stk::setSampleRate(MOBILEMUSIC_SRATE);
    
    reverb = new stk::NRev;
    reverb->setT60(3);
    reverb->setEffectMix(0.1);
}

void MMAudio::start()
{
    MoAudio::init(MOBILEMUSIC_SRATE, 512, 2);
    MoAudio::start(::audio_callback, this);    
}

void MMAudio::add(FlareSound * fs)
{
    addList.put(fs);
}

void MMAudio::remove(FlareSound * fs)
{
    removeList.put(fs);
}

void MMAudio::audio_callback(Float32 * buffer, UInt32 numFrames)
{
    // handle add/remove operations from the graphics/UI thread
    FlareSound * fs = NULL;
    while(addList.get(fs))
        flareSounds.push_back(fs);
    while(removeList.get(fs))
    {
        flareSounds.remove(fs);
        fs->destroy();
        delete fs;
    }
    
    // render audio samples
    for(int i = 0; i < numFrames; i++)
    {
        // stereo interleaved operation
        float sample = 0;
        
        // render each flare
        for(std::list<FlareSound *>::iterator i = flareSounds.begin(); i != flareSounds.end(); i++)
        {
            sample += (*i)->tick();
        }
        
        // run mix through central reverb
        sample = reverb->tick(sample);
        
        // copy mono sample to stereo buffer
        buffer[i*2] = sample;
        buffer[i*2+1] = sample;
    }
}

