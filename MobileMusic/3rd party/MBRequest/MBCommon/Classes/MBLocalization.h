//
//  MBLocalization.h
//  MBCommon
//
//  Created by Sebastian Celis on 2/28/12.
//  Copyright (c) 2012 Mobiata, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// This is a helpful macro to try and make localization within the MBCommon project simple. It
// allows people to add the string to their existing Localizable.strings file if they want to
// translate it themselves. Or, they can set MBLocalizationTable and keep these strings
// sequestered in their own files which they can either create themselves or even import from
// someone else.
#ifdef MBLocalizationTable
#define MBLocalizedString(key, default) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:(default) table:MBLocalizationTable]
#else
#define MBLocalizedString(key, default) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:(default) table:nil]
#endif
