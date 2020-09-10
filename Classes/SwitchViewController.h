//
//  SwitchViewController.h
//  iGendyn
//
//  Created by Nicholas Collins on 22/05/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "GendynPreset.h"
#import "AudioDeviceManager.h"
#import "AudioDeviceManager.h"

@class PerformViewController;
@class EditPresetViewController;
@class EditBankViewController;

extern GendynPreset *gendynpresets_[NUMPRESETS]; //array of them 

@interface SwitchViewController : UIViewController {

@public
	PerformViewController *performViewController; 
	EditBankViewController *editBankViewController; 
	EditPresetViewController *editPresetViewController; 
	NSTimer * timer; 
	AudioDeviceManager *audio; 
	int onwhich; 
	
	IBOutlet UIButton* leftbutton;
	IBOutlet UIButton* rightbutton;
}

@property (retain, nonatomic) PerformViewController *performViewController; 
@property (retain, nonatomic) EditBankViewController *editBankViewController; 
@property (retain, nonatomic) EditPresetViewController *editPresetViewController; 
@property (retain, nonatomic) AudioDeviceManager *audio; 
@property (retain, nonatomic) UIButton* leftbutton; 
@property (retain, nonatomic) UIButton* rightbutton; 

-(IBAction) selectPreset:(id)sender; 
-(IBAction) switchViews:(id)sender; 
-(IBAction) switchViewToBank:(id)sender; //other switch possibility
-(void)switchViewsActual:(id)sender withChoice:(int)which;
-(void)timerUpdatePerformView:(NSTimer*)timer;
//-(void)setup:(iGendynAppDelegate*)delegate; 

@end
