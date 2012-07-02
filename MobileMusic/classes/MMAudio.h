//
//  MMAudio.h
//  MobileMusic
//
//  Created by Spencer Salazar on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircularBuffer.h"
#import "NRev.h"
#import <list>

#define MOBILEMUSIC_SRATE (44100)

class FlareSound;

class MMAudio
{
public:
    static MMAudio * instance();
    
    MMAudio();
    void start();
    
    void audio_callback(Float32 * buffer, UInt32 numFrames);
    
    void add(FlareSound *f);
    void remove(FlareSound *f);
    
private:
    
    CircularBuffer<FlareSound *> addList;
    CircularBuffer<FlareSound *> removeList;
    
    std::list<FlareSound *> flareSounds;
    
    stk::NRev * reverb;
};
