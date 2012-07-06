//
//  ProgrammaticViewController.h
//  MobileMusic
//
//  Created by Mark on 7/5/12.
//

#import <UIKit/UIKit.h>

// this view controller illustrates how to construct a UI without the need for xibs
// there will be a slider that controls gain of audio and a label that prints
// debug information

@interface ProgrammaticViewController : UIViewController

// if using a xib file we would add the special IBOutlet identifier here so that
// InterfaceBuilder would know to hook up to these
//
// e.g. @property (nonatomic, strong) IBOutlet UILabel *outlettedSlider
//
@property (nonatomic, strong) UILabel *myLabel;
@property (nonatomic, strong) UISlider *mySlider;

@end
