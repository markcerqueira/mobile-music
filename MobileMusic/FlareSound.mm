//
//  FlareSound.mm
//  MobileMusic
//
//  Created by Spencer Salazar on 6/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#include "FlareSound.h"


FlareSound::FlareSound(float fs) :
m_fs(fs)
{
    
}

FlareSound::~FlareSound()
{
    
}


void FlareSound::init()
{
    m_wg.setPreset(3);
    m_wg.noteOn(220, 1.0);
    m_wg.startBowing(1.0, 2.0);
}


float FlareSound::tick()
{
    return m_wg.tick();
}


void FlareSound::destroy()
{
    
}
