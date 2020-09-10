//
//  AudioDeviceManager.mm
//  Concat
//
//  Created by Nicholas Collins on 24/04/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

//AVAudioSession`z


#import "AudioDeviceManager.h"

#include <AudioUnit/AudioUnit.h>
#include <AudioToolbox/AudioServices.h>

#include <stdio.h>
#include <stdlib.h>
#include <math.h>


//for determining device type
//from http://iphonedevelopertips.com/device/determine-if-iphone-is-3g-or-3gs-determine-if-ipod-is-first-or-second-generation.html
#include <sys/types.h>
#include <sys/sysctl.h>


@implementation AudioDeviceManager

AudioComponentInstance audioUnit;
AudioStreamBasicDescription audioFormat;
AudioBufferList* bufferList;
BOOL startedCallback;
BOOL noInterrupt; 


//
//static OSStatus recordingCallback(void* inRefCon,AudioUnitRenderActionFlags* ioActionFlags,const AudioTimeStamp* inTimeStamp,UInt32 inBusNumber,UInt32 inNumberFrames,AudioBufferList* ioData)
//{
//	
//	AudioDeviceManager *manager = (AudioDeviceManager *)inRefCon;
//	
//	//	if(remoteIOplayer->debugcollected<10) {
//	//		
//	//		 remoteIOplayer->debugcheck[remoteIOplayer->debugcollected]= (int)inNumberFrames; 
//	//		
//	//		remoteIOplayer->debugcollected++; 	
//	//	}
//	
//	//AudioRIO* audioRIO = (AudioRIO*) inRefCon;
//	//ioData = audioRIO.bufferList;
//
//	if(startedCallback && noInterrupt) {
//		
//		OSStatus result = AudioUnitRender(audioUnit,ioActionFlags,inTimeStamp,inBusNumber,inNumberFrames,bufferList);
//		
//		
//		switch(result)
//		{
//			case noErr:
//			{
//				//doSomethingWithAudioBuffer((SInt16*)audioRIO.bufferList->mBuffers[0].mData,inNumberFrames);
//				
//				//stay absolutely locked, outputcallback comes after inputcallback I think in AUGraph
//				//NSLog(@"numFrames %d input count %d output count %d \n", inNumberFrames, inputcallbacktest, outputcallbacktest); 
//				//inputcallbacktest += inNumberFrames; 
//				
//				break;
//			}
//			case kAudioUnitErr_InvalidProperty: NSLog(@"AudioUnitRender Failed: Invalid Property"); break;
//			case -50: NSLog(@"AudioUnitRender Failed: Invalid Parameter(s)"); break;
//			default: NSLog(@"AudioUnitRender Failed: Unknown (%d)",result); break;
//		}
//		
//	}
//	
//	return noErr;
//}
//






//static unsigned long g_countertest = 0; 

/* Parameters on entry to this function are :-
 
 *inRefCon - used to store whatever you want, can use it to pass in a reference to an objectiveC class
 i do this below to get at the InMemoryAudioFile object, the line below :
 callbackStruct.inputProcRefCon = self;
 in the initialiseAudio method sets this to "self" (i.e. this instantiation of RemoteIOPlayer).
 This is a way to bridge between objectiveC and the straight C callback mechanism, another way
 would be to use an "evil" global variable by just specifying one in theis file and setting it
 to point to inMemoryAudiofile whenever it is set.
 
 *inTimeStamp - the sample time stamp, can use it to find out sample time (the sound card time), or the host time
 
 inBusnumber - the audio bus number, we are only using 1 so it is always 0 
 
 inNumberFrames - the number of frames we need to fill. In this example, because of the way audioformat is
 initialised below, a frame is a 32 bit number, comprised of two signed 16 bit samples.
 
 *ioData - holds information about the number of audio buffers we need to fill as well as the audio buffers themselves */
static OSStatus playbackCallback(void *inRefCon, 
								 AudioUnitRenderActionFlags *ioActionFlags, 
								 const AudioTimeStamp *inTimeStamp, 
								 UInt32 inBusNumber, 
								 UInt32 inNumberFrames, 
								 AudioBufferList *ioData) {  
	
	int i, j; 
	
	
	if(startedCallback && noInterrupt) {
		
		//get a copy of the objectiveC class "self" we need this to get the next sample to fill the buffer
		AudioDeviceManager *manager = (AudioDeviceManager *)inRefCon;
	
		//loop through all the buffers that need to be filled
		for (i = 0 ; i < ioData->mNumberBuffers; i++){
			//get the buffer to be filled
			AudioBuffer buffer = ioData->mBuffers[i];
			//printf("which buf %d numberOfSamples %d channels %d countertest %d \n", i, buffer.mDataByteSize, buffer.mNumberChannels, g_countertest);
			
			//if needed we can get the number of bytes that will fill the buffer using
			// int numberOfSamples = ioData->mBuffers[i].mDataByteSize;
			
			//get the buffer and point to it as an UInt32 (as we will be filling it with 32 bit samples)
			//if we wanted we could grab it as a 16 bit and put in the samples for left and right seperately
			//but the loop below would be for(j = 0; j < inNumberFrames * 2; j++) as each frame is a 32 bit number
			//UInt32 *frameBuffer = buffer.mData;
			
			short signed int *frameBuffer = (short signed int *)buffer.mData;
			
			//safety first
			inNumberFrames= inNumberFrames<4000?inNumberFrames:4000; 
			
			float * tempbuf= manager->tempbuf;
			
			
			//remoteIOplayer->mGendyn->calculate(inNumberFrames,tempbuf); 
			//zero before summing in sounds
			for (j = 0; j < inNumberFrames; j++)
				tempbuf[j]=0.0;
			
			//ACCUMULATE
			for (j = 0; j < NUMBEROFGENDYNS; j++)
				manager->mGendyn[j]->calculate(inNumberFrames,tempbuf); 
			
			float mult = 32767.0/NUMBEROFGENDYNS; //easy way to avoid overloads? SHOULD really compress... keep same if below 0.5 else to 0.5 + 0.5*((total-0.5)/(NUMBEROFGENDYNS- 0.5))
			
			//loop through the buffer and fill the frames
			for (int j = 0; j < inNumberFrames; j++){
				// get NextPacket returns a 32 bit value, one frame.
				//frameBuffer[j] = [[remoteIOplayer inMemoryAudioFile] getNextPacket];
				//float value= 32767.0*sin((400*2*3.14159)*(j/44100.0)); 
				float value= mult*tempbuf[j]; //sin((400*2*3.14159)*(g_countertest/44100.0)); 
				
				frameBuffer[2*j] = value; 
				frameBuffer[2*j+1] = value; 
				
				//++g_countertest; 
			}
		}
	
		
	} else {
		
		for (i = 0 ; i < ioData->mNumberBuffers; i++){
			AudioBuffer buffer = ioData->mBuffers[i];

			short signed int *frameBuffer = (short signed int *)buffer.mData;
						
			//loop through the buffer and fill the frames
			for (j = 0; j < inNumberFrames; j++){
		
				short signed int value= 32767.0*0.0; 
				frameBuffer[2*j] = value;	
				frameBuffer[2*j+1] = value; 
				
				//++g_countertest; 
			}
			
		}
		
	}
	
	
    return noErr;
}


//-(void)soundOff {
//	//make sure set to silent
//		mInstruction->running=0; 
//	
//}



void callbackInterruptionListener(void* inClientData, UInt32 inInterruption)
{
	NSLog(@"audio interruption %lu",inInterruption);
	
	AudioDeviceManager *manager = (AudioDeviceManager *)inClientData;
	
	
	//kAudioSessionEndInterruption =0,  kAudioSessionBeginInterruption  = 1
	if(inInterruption) {
		noInterrupt = NO;
		
		[manager closeDownAudioDevice];
		
		startedCallback	= NO;
		
	}
	else {
		
		if (noInterrupt==NO) {
			
			[manager setUpAudioDevice]; //restart audio session
			
			noInterrupt = YES;
			
		}
		
	}
}


-(void)interruptionstarted {
    noInterrupt = NO;
    
    [self closeDownAudioDevice];
    
    startedCallback	= NO;
}

-(void) interruptionended {
    if (noInterrupt==NO) {
        
        [self setUpAudioDevice]; //restart audio session
        
        noInterrupt = YES;
        
    }
    
}





//not used at present
void audioRouteChangeListenerCallback(void * inClientData,AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize,const void * inPropertyValue) {
	
	
	
	// ensure that this callback was invoked for a route change
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
	
	
	
    // This callback, being outside the implementation block, needs a reference to the
    //      MainViewController object, which it receives in the inUserData parameter.
    //      You provide this reference when registering this callback (see the call to 
    //      AudioSessionAddPropertyListener).
    //MainViewController *controller = (MainViewController *) inUserData;
    
    // if application sound is not playing, there's nothing to do, so return.
	//  if (controller.appSoundPlayer.playing == 0 ) {
	//		
	//        NSLog (@"Audio route change while application audio is stopped.");
	//        return;
	//        
	//    } else {
	
	// Determines the reason for the route change, to ensure that it is not
	//      because of a category change.
	CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;
	
	CFNumberRef routeChangeReasonRef = (CFNumberRef)CFDictionaryGetValue(routeChangeDictionary,CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
	
	SInt32 routeChangeReason;
	
	CFNumberGetValue (
					  routeChangeReasonRef,
					  kCFNumberSInt32Type,
					  &routeChangeReason
					  );
	
	//	if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) 
	//	{
	//		
	//		//NSLog(@"Headset is unplugged.."); 
	//		
	//		
	//		
	//	}
	//	if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable)
	//	{
	//		//NSLog(@"Headset is plugged in..");                                
	//	}
	
	AudioDeviceManager *manager = (AudioDeviceManager *)inClientData;
	
	
	if ((routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) || (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable)) {
		
		
		startedCallback	= NO;
		[manager closeDownAudioDevice];
		
		OSStatus err= [manager setUpAudioDevice]; //restart audio session
		
		//	if(err!=noErr) {
		//		
		//			//UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Hit Home button to exit" message:@"Problem with audio setup; are you on an ipod touch without headphone microphone? Concat requires audio input, please set this up then restart app" delegate:manager cancelButtonTitle:nil otherButtonTitles:nil];
		//			//[anAlert show];
		//		
		//		}
		
	}
	
	
}


//for:
////2.2 and later
//kAudioSessionProperty_AudioInputAvailable
//kAudioSessionProperty_ServerDied
//void propertyListener(void* inClientData,AudioSessionPropertyID inID,UInt32 inDataSize,const void* inData)
//{
//	NSLog(@"propListener");
//}



-(void)setUpData {
	
	
	for (int i=0; i<NUMBEROFGENDYNS; ++i)
		mGendyn[i] = new GendynSynthesis(44100.0); 
	
//	bufferList = (AudioBufferList*) malloc(sizeof(AudioBufferList));
//	bufferList->mNumberBuffers = 1; //audioFormat.mChannelsPerFrame;
//	for(UInt32 i=0;i<bufferList->mNumberBuffers;i++)
//	{
//		bufferList->mBuffers[i].mNumberChannels = 1;
//		bufferList->mBuffers[i].mDataByteSize = (1024*2) * 2; //is 2, //audioFormat.mBytesPerFrame;
//		bufferList->mBuffers[i].mData = malloc(bufferList->mBuffers[i].mDataByteSize);
//	}
	
	
}

-(void)freeData {
	
//	for(UInt32 i=0;i<bufferList->mNumberBuffers;i++) {
//		free(bufferList->mBuffers[i].mData);
//	}
//	
//	free(bufferList);
	
	for(int i=0; i<NUMBEROFGENDYNS; ++i)
			delete mGendyn[i]; 
}









#define kOutputBus 0
#define kInputBus 1

-(OSStatus)setUpAudioDevice {
	OSStatus status;
	
	startedCallback = NO;
	noInterrupt = YES;
    
	//NSLog(@"checkinit %d \n",checkinit);
	
	// Describe audio component
	AudioComponentDescription desc;
	desc.componentType = kAudioUnitType_Output;
	desc.componentSubType = kAudioUnitSubType_RemoteIO;
	desc.componentFlags = 0;
	desc.componentFlagsMask = 0;
	desc.componentManufacturer = kAudioUnitManufacturer_Apple;
	
    
	// Get component
	AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
	
	// Get audio units
	status = AudioComponentInstanceNew(inputComponent, &audioUnit);
	
	UInt32 flag = 1;
	// Enable IO for playback
	status = AudioUnitSetProperty(audioUnit,
								  kAudioOutputUnitProperty_EnableIO,
								  kAudioUnitScope_Output,
								  kOutputBus,
								  &flag,
								  sizeof(flag));
    
	// Describe format
	audioFormat.mSampleRate			= 44100.00;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 2;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 4;
	audioFormat.mBytesPerFrame		= 4;
	
	//Apply format
	status = AudioUnitSetProperty(audioUnit,
								  kAudioUnitProperty_StreamFormat,
								  kAudioUnitScope_Input,
								  kOutputBus,
								  &audioFormat,
								  sizeof(audioFormat));
    
    
	// Set up the playback  callback
	AURenderCallbackStruct callbackStruct;
	callbackStruct.inputProc = playbackCallback;
	//set the reference to "self" this becomes *inRefCon in the playback callback
	callbackStruct.inputProcRefCon = self;
	
	status = AudioUnitSetProperty(audioUnit,
								  kAudioUnitProperty_SetRenderCallback,
								  kAudioUnitScope_Global,
								  kOutputBus,
								  &callbackStruct,
								  sizeof(callbackStruct));
    
    
	if(status!= noErr) {
		
		NSLog(@"failure at AudioUnitSetProperty 6\n");
		
		return status;
	};
	
	status = AudioUnitInitialize(audioUnit);
	
	if(status == noErr)
	{
        
	}
	else {
		
		NSLog(@"failure at AudioUnitSetProperty 8\n");
		
		return status;
	}
	
	status = AudioOutputUnitStart(audioUnit);
	
	if (status == noErr) {
		
		audioproblems = 0;
        
		startedCallback = YES;
        
	}
	
	return status;
    
	
}




-(void)closeDownAudioDevice{
	
	
	OSStatus status = AudioOutputUnitStop(audioUnit);
	
	if(startedCallback) {
		
        //for(UInt32 i=0;i<bufferList->mNumberBuffers;i++) {
        //		free(bufferList->mBuffers[i].mData);
        //	}
        //
        //	free(bufferList);
        
        startedCallback	= NO;
		
	}
    
	AudioUnitUninitialize(audioUnit);
	
	//AudioSessionSetActive(false);
	//delete mInstruction; //only one in this app for now
	
	//	for(int i=0; i<NUMBEROFGENDYNS; ++i)
	//		delete mGendyn[i]; 
	
}




//
//-(void)closeDownAudioDevice{
//	
//	
//	OSStatus status = AudioOutputUnitStop(audioUnit);
//	
//	if(startedCallback) {
//		
//	//for(UInt32 i=0;i<bufferList->mNumberBuffers;i++) {
////		free(bufferList->mBuffers[i].mData);
////	}
////	
////	free(bufferList);
//	
//	startedCallback	= NO;
//		
//	}
//		
//	AudioUnitUninitialize(audioUnit);
//	
//	AudioSessionSetActive(false);
//	//delete mInstruction; //only one in this app for now
//	
//	//	for(int i=0; i<NUMBEROFGENDYNS; ++i)
//	//		delete mGendyn[i]; 
//	
//}
//
//



//-(OSStatus)start{
//	
//	OSStatus status = AudioOutputUnitStart(audioUnit);
//	
//	startedCallback = YES;
//	
//	return status;
//}
//
//-(OSStatus)stop{
//	
//	startedCallback = NO;
//	
//	delete concatsynth; 
//	
//	OSStatus status = AudioOutputUnitStop(audioUnit);
//	
//	for(UInt32 i=0;i<bufferList->mNumberBuffers;i++) {
//		free(bufferList->mBuffers[i].mData);
//	}
//	
//	free(bufferList);
//
//	
//	//delete mInstruction; 
//	return status;
//}






/*

// Below code is a cut down version (for output only) of the code written by
// Micheal "Code Fighter" Tyson (punch on Mike)
// See http://michael.tyson.id.au/2008/11/04/using-remoteio-audio-unit/ for details
-(OSStatus)setUpAudioDevice {
	OSStatus status;
	
	startedCallback = NO;
	noInterrupt = YES;
    
	//NSLog(@"checkinit %d \n",checkinit);
	
	// Describe audio component
	AudioComponentDescription desc;
	desc.componentType = kAudioUnitType_Output;
	desc.componentSubType = kAudioUnitSubType_RemoteIO;
	desc.componentFlags = 0;
	desc.componentFlagsMask = 0;
	desc.componentManufacturer = kAudioUnitManufacturer_Apple;
	
	//Audio Session Services Reference
	
	//http://www.iwillapps.com/wordpress/?p=196
	//setup AudioSession for safety (interruption handling):
	AudioSessionInitialize(NULL,NULL,callbackInterruptionListener,self);
	AudioSessionSetActive(true);
	
	//AudioSessionGetProperty(AudioSessionPropertyID inID,UInt32 *ioDataSize, void *outData);
	UInt32 sizeofdata;
    
	NSLog(@"Audio session details\n");
	
    //	UInt32 audioavailableflag;
    //
    //	//2.2 and later
    //	//kAudioSessionProperty_AudioInputAvailable
    //
    //	//can check whether input plugged in
    //	sizeofdata= sizeof(audioavailableflag);
    //	status= AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable,&sizeofdata,&audioavailableflag);
    //
    //	//no input capability
    //	if(audioavailableflag==0) {
    //
    //		//will force system to show no audio input device message.
    //		return 1;
    //	}
    //
	
	
    //	NSLog(@"Audio Input Available? %d \n",audioavailableflag);
    //
	UInt32 numchannels;
    //	sizeofdata= sizeof(numchannels);
    //	//problematic: gives number of potential inputs, not number actually connected
    //	status= AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels,&sizeofdata,&numchannels);
    //
    //	NSLog(@"Inputs %d \n",numchannels);
	
	sizeofdata= sizeof(numchannels);
	status= AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareOutputNumberChannels,&sizeofdata,&numchannels);
	
	NSLog(@"Outputs %lu \n",numchannels);
	
	
	Float64 samplerate;
	samplerate = 44100.0; //44100.0; //supports and changes to 22050.0 or 48000.0 too!; //44100.0;
	status= AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate,sizeof(samplerate),&samplerate);
	
	sizeofdata= sizeof(samplerate);
	status= AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate,&sizeofdata,&samplerate);
    
	NSLog(@"Device sample rate %f \n",samplerate);
	
	//set preferred hardward buffer size of 1024
	
	
	Float32 iobuffersize = 1024.0/44100.0;
	status= AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration,sizeof(iobuffersize),&iobuffersize);
	
	
	sizeofdata= sizeof(iobuffersize);
	status= AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareIOBufferDuration,&sizeofdata,&iobuffersize);
	
	NSLog(@"Hardware buffer size %f \n",iobuffersize);
	
	
	//// read-only
	//kAudioSessionProperty_CurrentHardwareInputNumberChannels   = 'chic',
	// read-only
	//kAudioSessionProperty_CurrentHardwareOutputNumberChannels  = 'choc',
	// read-only
	// kAudioSessionProperty_CurrentHardwareIOBufferDuration      = 'chbd',
	// read-only
	//kAudioSessionProperty_AudioInputAvailable                  = 'aiav',
	// read-only + callback function
	//kAudioSessionProperty_PreferredHardwareSampleRate          = 'hwsr',
	// read/write
	//kAudioSessionProperty_PreferredHardwareIOBufferDuration    = 'iobd',
	// read/write
	
    
	UInt32 audioCategory = kAudioSessionCategory_MediaPlayback; //for output audio //kAudioSessionCategory_PlayAndRecord; //both input and output
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,sizeof(audioCategory),&audioCategory);
	
	
	//probably not necessary, only for kAudioSessionCategory_PlayAndRecord, but here just in case
	//to find device type
    //	size_t size;
    //
    //	// Set 'oldp' parameter to NULL to get the size of the data
    //	// returned so we can allocate appropriate amount of space
    //	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    //	// Allocate the space to store name
    //	char *name = (char *) malloc(size);
    //	// Get the platform name
    //	sysctlbyname("hw.machine", name, &size, NULL, 0);
    //	// Place name into a string
    //
    //
    //	//NSStringEncoding
    //	//NSString *machine = [NSString stringWithCString:name];
    //	NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    //	NSLog(@"device: %@", machine);
    //	//string begins iPhone or iPod, so check third character!
    //	if (name[2]=='h') {
    //		//if iPhone force to fuller loudspeaker mode
    //		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //		AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    //	}
    //
    //	// Done with this
    //	free(name);
    //
	
	
	//Float64 desiredsamplerate= 44100.0;
	//kAudioSessionProperty_PreferredHardwareSampleRate
	//set below anyway for audio unit?
	
	//http://developer.apple.com/iphone/library/documentation/AudioToolbox/Reference/AudioSessionServicesReference/Reference/reference.html#//apple_ref/doc/constant_group/Audio_Session_Route_Change_Reasons
	//general feedback on states of device changing
	//AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,propertyListener,self);
    //
	// Registers the audio route change listener callback function
	AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback,self);
	
	
	
	
	// Get component
	AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
	
	// Get audio units
	status = AudioComponentInstanceNew(inputComponent, &audioUnit);
	
	if(status!= noErr) {
		
		NSLog(@"failure at AudioComponentInstanceNew\n");
		
		return status;
		
	};
	
	UInt32 flag = 1;
	UInt32 kOutputBus = 0;
	UInt32 kInputBus = 1;
	
    //	// Enable IO for recording
    //	status = AudioUnitSetProperty(audioUnit,
    //								  kAudioOutputUnitProperty_EnableIO,
    //								  kAudioUnitScope_Input,
    //								  kInputBus,
    //								  &flag,
    //								  sizeof(flag));
    //	//checkStatus(status);
    //
    //	if(status!= noErr) {
    //
    //		NSLog(@"failure at AudioUnitSetProperty 1\n");
    //
    //		return status;
    //	};
	
	// Enable IO for playback
	status = AudioUnitSetProperty(audioUnit,
								  kAudioOutputUnitProperty_EnableIO,
								  kAudioUnitScope_Output,
								  kOutputBus,
								  &flag,
								  sizeof(flag));
	
	
	if(status!= noErr) {
		
		NSLog(@"failure at AudioUnitSetProperty 2\n");
		
		return status;
	};
	
	
	// Describe format
	audioFormat.mSampleRate			= 44100.00;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 2;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 4;
	audioFormat.mBytesPerFrame		= 4;
	
	//Apply format
	status = AudioUnitSetProperty(audioUnit,
								  kAudioUnitProperty_StreamFormat,
								  kAudioUnitScope_Input,
								  kOutputBus,
								  &audioFormat,
								  sizeof(audioFormat));
	
	
	if(status!= noErr) {
		
		NSLog(@"failure at AudioUnitSetProperty 3\n");
		
		return status;
	};
	
	
	
    //	//will be used by code below for defining bufferList, critical that this is set-up second
    //	// Describe format; not stereo for audio input!
    //	audioFormat.mSampleRate			= 44100.00;
    //	audioFormat.mFormatID			= kAudioFormatLinearPCM;
    //	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    //	audioFormat.mFramesPerPacket	= 1;
    //	audioFormat.mChannelsPerFrame	= 1;
    //	audioFormat.mBitsPerChannel		= 16;
    //	audioFormat.mBytesPerPacket		= 2;
    //	audioFormat.mBytesPerFrame		= 2;
    //
    //
    //	//for input recording
    //	status = AudioUnitSetProperty(audioUnit,
    //								  kAudioUnitProperty_StreamFormat,
    //								  kAudioUnitScope_Output,
    //								  kInputBus,
    //								  &audioFormat,
    //								  sizeof(audioFormat));
    //
    //
    //	if(status!= noErr) {
    //
    //		NSLog(@"failure at AudioUnitSetProperty 4\n");
    //
    //		return status;
    //	};
    //
	
	//setting up latency
	//float aBufferLength = 0.011609977324263; //0.005; // In seconds
	//	status= AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration,
	//							sizeof(aBufferLength), &aBufferLength);
    //
    //	if(status!= noErr) {
    //
    //		printf("failure at AudioUnitSetProperty 4.5\n");
    //	};
	
	// Set input callback
    //	AURenderCallbackStruct callbackStruct;
    //	callbackStruct.inputProc = recordingCallback;
    //	callbackStruct.inputProcRefCon = self;
    //	status = AudioUnitSetProperty(audioUnit,
    //								  kAudioOutputUnitProperty_SetInputCallback,
    //								  kAudioUnitScope_Global,
    //								  kInputBus,
    //								  &callbackStruct,
    //								  sizeof(callbackStruct));
    //
    //
    //
    //	if(status!= noErr) {
    //
    //		NSLog(@"failure at AudioUnitSetProperty 5\n");
    //
    //		return status;
    //	};
	
	// Set up the playback  callback
	AURenderCallbackStruct callbackStruct;
	callbackStruct.inputProc = playbackCallback;
	//set the reference to "self" this becomes *inRefCon in the playback callback
	callbackStruct.inputProcRefCon = self;
	
	status = AudioUnitSetProperty(audioUnit,
								  kAudioUnitProperty_SetRenderCallback,
								  kAudioUnitScope_Global,
								  kOutputBus,
								  &callbackStruct,
								  sizeof(callbackStruct));
	
	
	if(status!= noErr) {
		
		NSLog(@"failure at AudioUnitSetProperty 6\n");
		
		return status;
	};
	
    //
    //	UInt32 allocFlag = 1;
    //	status= AudioUnitSetProperty(audioUnit,kAudioUnitProperty_ShouldAllocateBuffer,kAudioUnitScope_Input,1,&allocFlag,sizeof(allocFlag)); // == noErr)
    //
    //
    //	if(status!= noErr) {
    //
    //		NSLog(@"failure at AudioUnitSetProperty 7\n");
    //
    //		return status;
    //	};
	
	
	//for audio interruption testing?
	//AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,propListener,self);
	
	
	status = AudioUnitInitialize(audioUnit);
	
	if(status == noErr)
	{
        //	bufferList = (AudioBufferList*) malloc(sizeof(AudioBufferList));
        //		bufferList->mNumberBuffers = audioFormat.mChannelsPerFrame;
        //		for(UInt32 i=0;i<bufferList->mNumberBuffers;i++)
        //		{
        //			bufferList->mBuffers[i].mNumberChannels = 1;
        //			bufferList->mBuffers[i].mDataByteSize = (1024*2) * audioFormat.mBytesPerFrame;
        //			bufferList->mBuffers[i].mData = malloc(bufferList->mBuffers[i].mDataByteSize);
        //		}
        //		
	}
	else {
		
		NSLog(@"failure at AudioUnitSetProperty 8\n"); 
		
		return status; 
	}	
	
	status = AudioOutputUnitStart(audioUnit);
	
	if (status == noErr) {
		
		audioproblems = 0; 
        
		startedCallback = YES;
        
	}
	
	return status; 
	
}

*/


@end
