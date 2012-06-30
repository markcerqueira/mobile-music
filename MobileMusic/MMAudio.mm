//
//  MMAudio.m
//  MobileMusic
//
//  Created by Spencer Salazar on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "MMAudio.h"
#import "mo_audio.h"
#import "BandedWG.h"


void audio_callback(Float32 * buffer, UInt32 numFrames, void * userData)
{
    MMAudio * mmaudio = (MMAudio *) userData;
    
    mmaudio->audio_callback(buffer, numFrames);
}

MMAudio::MMAudio()
{
    p = 0;
}

void MMAudio::start()
{
    MoAudio::init(44100, 512, 2);
    MoAudio::start(::audio_callback, this);    
    
    stk::Stk::setSampleRate(44100);
    
    wg = stk::BandedWG();
    wg.setFrequency(220);
    wg.controlChange(16, 3);
//    wg.controlChange(2, 20);
//    wg.controlChange(4, 20);
//    wg.controlChange(128, 20);
    wg.controlChange(1, 1.0);
    wg.noteOn(220, 1.0);
    wg.startBowing(1.0, 1.0);
}

void MMAudio::audio_callback(Float32 * buffer, UInt32 numFrames)
{
    for(int i = 0; i < numFrames; i++)
    {
        // stereo interleaved operation
//        buffer[i*2] = sinf(p*220.0/44100.0*2*M_PI);
//        buffer[i*2+1] = sinf(p*220.0/44100.0*2*M_PI);
        float samp = wg.tick();
        buffer[i*2] = samp;
        buffer[i*2+1] = samp;
        p++;
    }
}

