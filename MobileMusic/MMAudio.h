//
//  MMAudio.h
//  MobileMusic
//
//  Created by Spencer Salazar on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

class MMAudio
{
public:
    MMAudio();
    void start();
    
    void audio_callback(Float32 * buffer, UInt32 numFrames);
    
private:
    
    float p;
};