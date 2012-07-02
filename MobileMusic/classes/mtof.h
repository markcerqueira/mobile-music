//
//  mtof.h
//  MobileMusic
//
//  Created by Spencer Salazar on 7/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#ifndef MobileMusic_mtof_h
#define MobileMusic_mtof_h

//-----------------------------------------------------------------------------
// name: mtof()
// desc: midi to freq
//-----------------------------------------------------------------------------
double mtof( double f )
{
    if( f <= -1500 ) return (0);
    else if( f > 1499 ) return (mtof(1499));
    // else return (8.17579891564 * exp(.0577622650 * f));
    // TODO: optimize
    else return ( pow(2,(f-69)/12.0) * 440.0 );
}


#endif
