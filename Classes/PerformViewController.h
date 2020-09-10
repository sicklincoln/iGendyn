//
//  PerformViewController.h
//  iGendyn
//
//  Created by Nicholas Collins on 22/05/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AudioDeviceManager.h"
#import "GendynPreset.h"

#import <CoreMotion/CoreMotion.h>

//@class AudioDeviceManager;

@interface PerformViewController : UIViewController <UIAccelerometerDelegate> {
@public
    CMMotionManager *motionManager;
    
	//AudioManager *player;
	int mActiveTouches; 
	void * mTouchAddresses[NUMBEROFGENDYNS]; //NUMBEROFGENDYNS but need to include header, then would have to make other files .mm

	//int accelactive; 
	AudioDeviceManager *audio; 
	GendynPreset * currentpreset; 
	int currentpresetindex; 
}

@property (readonly) CMMotionManager *motionManager;

- (void)setupaccelerometer; 
-(BOOL)noTouches; 

@end
