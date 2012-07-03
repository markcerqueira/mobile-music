//
//  MBJSON.h
//  MBCommon
//
//  Created by Sebastian Celis on 2/28/12.
//  Copyright (c) 2012 Mobiata, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

id MBJSONObjectFromData(NSData *data, NSError **error);
NSData *MBJSONDataFromObject(id object, NSError **error);
