//
//  Filepaths.h
//  
//
//  Created by Spencer Salazar on 7/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#ifndef _Filepaths_h
#define _Filepaths_h


static std::string stlDocumentsFilepath(const char * relativePath)
{
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    std::string filepath = std::string([documentsDirectory UTF8String]) + "/" + relativePath;
    return filepath;
}

static std::string stlResourceFilepath(const char * relativePath)
{
    NSString * filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithCString:relativePath
                                                                                    encoding:NSUTF8StringEncoding]
                                                          ofType:@""];
    return std::string([filepath UTF8String]);
}
                           

#endif


