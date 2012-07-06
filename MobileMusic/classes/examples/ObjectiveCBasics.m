//
//  ObjectiveCBasics.m
//  MobileMusic
//
//  Created by Mark on 7/5/12.
//

#import "ObjectiveCBasics.h"

// if you want to define more methods that are private to a class, you can have an interface that lives
// in your .m file
//
// only methods inside this file will be able to see this content
@interface ObjectiveCBasics ()

- (void)privateMethod;

@end


// everything between @implementation and @end should implement the methods in the @interface
@implementation ObjectiveCBasics

// here we synthesize the getters and setters for our properties
// this allows us to set and get the values easily (e.g. self.propertyString = @"HELLO!")
@synthesize propertyString;
@synthesize myFloatValue;

- (BOOL)performActionOnMyObject
{
    return YES;
}

+ (void)printOutClassDescription
{
    // NSLog is the Objective-C equivalent of cout or printf
    NSLog(@"Hello world");    
}

// privateMethods can be defined and used in the implementation of files without any issue
- (void)privateMethod
{
    
}

- (void)addPersonToDatabase:(NSString *)personalIdentifier
{
    [self privateMethod];
}

- (void)addFamilyToDatabase:(NSString *)familyIdentifier numberOfMembersInFamily:(NSInteger)count
{
    
}

// how to do default arguments in Objective-C
- (void)methodWithNoArg1
{
    [self methodWithArg1:@"DEFAULT-1"];
}

- (void)methodWithArg1:(NSString *)arg1
{
    [self methodWithArg1:@"DEFAULT-1" andArg2:@"DEFAULT-2"];
}

- (void)methodWithArg1:(NSString *)arg1 andArg2:(NSString *)arg2
{
    NSLog(@"Value of arg1 is %@ and value of arg2 is %@", arg1, arg2);
}

@end
