//
//  ObjectiveCBasics.h
//  MobileMusic
//
//  Created by Mark on 7/5/12.
//

#import <Foundation/Foundation.h>

// a header file in Objective-C defines public methods/properties that can be accessed
// by external classes

// interface declarations begin with this @interface declaration and terminate at @end
// the name of this class is ObjectiveCBasics and this class inherits from NSObject
// NSObject is a root class (most things inherit from it in some way)
// view controllers inherit from UIViewController
@interface ObjectiveCBasics : NSObject
{
    // you can declare objects are in traditional i-var style here
    NSString *myString;
    
    // Objective-C is a superset of C so you can C primitives/objects if you'd like too!
    int i;
}

// this is a method in Objective-C syntax
// the - means the method is an object/instance method (you'll need an instance of ObjectiveCBasics to call this method)
// the type between parantheses defines the return type - in this case a BOOL (boolean)
//
// example:
// ObjectiveCBasics *myObjectiveCBasicsObject = [[ObjectiveCBasics alloc] init];
// [myObjectiveCBasicsObject performActionOnMyObjective];
//
// note that instead of the traditional object.method() or object->method(), in Objective-C you use square brackets
// to call methods
- (BOOL)performActionOnMyObject;

// this method is different from the above because it is a class method (denoted by the + sign)
// this means you do not need an instance of the class to call this method - you invoke it directly
//
// example:
// [ObjectiveCBasics printOutClassDescription];
//
// note that static methods do not have access to i-vars/properties because those are allocated
// when you allocate an object
+ (void)printOutClassDescription;

// this method takes an argument (a string) denoted by personalIdentifier
// 
// example:
// [myObjectiveCBasicsObject addPersonToDatabase:@"Spencer Salazar"];
- (void)addPersonToDatabase:(NSString *)personalIdentifier;

// this method takes 2 arguments (a string and number) denoted by familyIdentifier and count
//
// example:
// [myObjectiveCBasicsObject addFamilyToDatabase:@"Salazar222" numberOfMembersInFamily:4];
- (void)addFamilyToDatabase:(NSString *)familyIdentifier numberOfMembersInFamily:(NSInteger)count;

// properties are like instance variables, but add memory management and setters/getters automatically for you
// declared properties need to be synthesized (e.g. @synthesize propertyString) in the implementation of your class
// so that getters and setters are created
//
// strong vs assign defines the memory management - if you are using primitive types use assign; if you are managing
// objects use strong and your class will keep a strong reference to the object so it won't get deallocated unless
// your instance of the class is deallocated
@property (strong) NSString *propertyString;
@property (assign) float myFloatValue;

// there currently is no feature to allow default arguments to be used in Objective-C
// if you want methods with default arguments create versions that take one less argument and pass the default argument
// up in the implementation
- (void)methodWithNoArg1;
- (void)methodWithArg1:(NSString *)arg1;
- (void)methodWithArg1:(NSString *)arg1 andArg2:(NSString *)arg2;

@end
