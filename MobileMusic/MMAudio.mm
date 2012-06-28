//
//  MMAudio.m
//  MobileMusic
//
//  Created by Spencer Salazar on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "MMAudio.h"
#import "mo_audio.h"



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
}

void MMAudio::audio_callback(Float32 * buffer, UInt32 numFrames)
{
    for(int i = 0; i < numFrames; i++)
    {
        // stereo interleaved operation
        buffer[i*2] = sinf(p*220.0/44100.0*2*M_PI);
        buffer[i*2+1] = sinf(p*220.0/44100.0*2*M_PI);
        p++;
    }
}
