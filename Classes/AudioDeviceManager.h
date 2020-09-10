//
//  AudioDeviceManager.h
//  Concat
//
//  Created by Nicholas Collins on 24/04/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "GendynSynthesis.h"

@interface AudioDeviceManager : NSObject {

@public
	float tempbuf[1024];
	//float inputbuf[1024]; 
	float outputbuf[1024]; 
	int audioproblems; 
	
	
	//ConcatSynth * concatsynth; 
	GendynSynthesis	*mGendyn[NUMBEROFGENDYNS]; 
	
}

//-(OSStatus)start;
//-(OSStatus)stop;

-(void)setUpData;
-(void)freeData;

-(void)closeDownAudioDevice;
-(OSStatus)setUpAudioDevice;

-(void)interruptionstarted;
-(void)interruptionended;

@end
