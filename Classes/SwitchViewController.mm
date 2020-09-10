//
//  SwitchViewController.m
//  iGendyn
//
//  Created by Nicholas Collins on 22/05/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import "SwitchViewController.h"
#import "PerformViewController.h"
#import "EditPresetViewController.h"
#import "EditBankViewController.h"
#include <AVFoundation/AVAudioSession.h>


@implementation SwitchViewController

@synthesize performViewController;
@synthesize editPresetViewController;
@synthesize editBankViewController;
@synthesize audio;
@synthesize leftbutton;
@synthesize rightbutton;

GendynPreset *gendynpresets_[NUMPRESETS]; //array of them 


- (void)viewDidLoad
{
	
	
	//SOMETHING WRONG HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	//this works, why not other code????????????????
	//int * testint= new int[140]; 
	//delete [] testint; 
	
	//GendynPreset * test = new GendynPreset(); 
	
	for (int i=0; i<NUMPRESETS; ++i) {
		GendynPreset * test = new GendynPreset(); 
		gendynpresets_[i] = test;
	}
	
	//call Default? 
	
	gendynpresets_[0]->Default1(); 
	gendynpresets_[1]->Default2(); 
	//gendynpresets_[2]->Default3(); 
	
	
	//gendynpresets_ = new GendynPreset[NUMPRESETS];
	
	//RETURNS NULL!!!!!!!!!!!!!!!!!!!WHY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	audio = [[AudioDeviceManager alloc] init];
	[audio retain]; 
	
	[audio setUpData]; //allocate buffers and concat
	//viewController->concatsynth_ = audio->concatsynth; 
	
	//initialise the audio player
	OSStatus status= [audio setUpAudioDevice]; 
	
	
	//	//do something to warn user! 
	//	if (status!= noErr) {
	//		//		//NSLog(@"PROBLEM with audio setup!"); 
	//		//		audio->audioproblems= 1; 
	//		//		
	//		viewController->microphonepluggedinatstart_ = 0; 
	//		//		
	//	} else {
	//		viewController->microphonepluggedinatstart_ = 1; 	
	//	}
	
	if(status!=noErr) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hit Home button to exit" message:@"Problem with audio setup, sorry." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[alert show];
		[alert release]; 	
	}
	
	
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AudioInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:session];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AudioInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:session];
	
	PerformViewController *controller = [[PerformViewController alloc] initWithNibName:@"PerformView" bundle:nil];
	self.performViewController = controller;
	
	onwhich = 0; //ie on base view
	
	controller->currentpresetindex = 0; 
	controller->audio= audio; 
	controller->currentpreset = gendynpresets_[0]; 
	
	
	int nowindex= controller->currentpresetindex;
	for (int i=0; i<NUMBEROFGENDYNS; ++i) {
		gendynpresets_[nowindex]->CopyToGendynSynthesis(audio->mGendyn[i]);
	}	
	
	[controller setupaccelerometer]; 
	//controller->accelactive= 1; 
	
	[self.view insertSubview:controller.view atIndex:0];
	
	controller.view.multipleTouchEnabled = YES;
	
	//set up drawing timer setNeedsDisplay
	//self.delegate
	//20 fps
	//now 25 fps
	timer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)0.04 target:self selector:@selector(timerUpdatePerformView:) userInfo:nil repeats:TRUE];
	[timer retain];
	
	
	
	
	//[self delegate]; 
	
	[controller release];
	
	
	//welcome screen
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Welcome to iGendyn!" message:@"Warning: iGendyn can be noisy, always take care of your ears! Instructions: you can create up to five voices with five independent touches. Tilt the device to control synthesis parameters with the accelerometer. Edit presets and banks of presets for different mappings and sound synthesis variations." delegate:nil cancelButtonTitle:@"Start" otherButtonTitles:nil];
	[alert show];
	[alert release]; 
}

//assuming called before viewDidLoad! 
//-(void)setup:(iGendynAppDelegate*)delegate




- (void)audioSessionInterrupted:(NSNotification*)notification {
    NSDictionary *interruptionDictionary = [notification userInfo];
    NSNumber *interruptionType = (NSNumber *)[interruptionDictionary valueForKey:AVAudioSessionInterruptionTypeKey];
    if ([interruptionType intValue] == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"Interruption started");
        [audio interruptionstarted];
        
        
    } else if ([interruptionType intValue] == AVAudioSessionInterruptionTypeEnded){
        NSLog(@"Interruption ended");
        [audio interruptionended];
        
        
    } else {
        NSLog(@"Something else happened");
    }
    
}



-(void)timerUpdatePerformView:(NSTimer*)timer {
	

	if(self.performViewController.view.superview != nil) {
		
	//NSLog(@"timer fires!");
		
	[self.performViewController.view setNeedsDisplay];
	}
	
}

//never called since never explicitly initialised in code
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//		// Initialization code
//		for (int i=0; i<NUMPRESETS; ++i) {
//			GendynPreset * test = new GendynPreset(); 
//			gendynpresets_[i] = test;
//		}
//		
//		
//	}
//	return self;
//}



-(IBAction) selectPreset:(id)sender {

	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	
	if([self.performViewController noTouches]) {
		
		int choice = [segment selectedSegmentIndex]; 
		
		performViewController->currentpresetindex = choice; 
		performViewController->currentpreset = gendynpresets_[choice];
		
		if (onwhich == 0) {
			int nowindex= performViewController->currentpresetindex;
			for (int i=0; i<NUMBEROFGENDYNS; ++i) {
				gendynpresets_[nowindex]->CopyToGendynSynthesis(audio->mGendyn[i]);
			}	
		}
					
		if(editPresetViewController) {
			editPresetViewController->currentpreset = gendynpresets_[choice];
			
			if (onwhich == 1)
				[editPresetViewController updateFromPreset]; 
			
							
			
		}
		
	} else {
		segment.selectedSegmentIndex = self.performViewController->currentpresetindex; 
	}
	
}


- (IBAction)switchViews:(id)sender
{
		[self switchViewsActual:sender withChoice:1];	
	
}


- (IBAction)switchViewToBank:(id)sender
{
	[self switchViewsActual:sender withChoice:2];
}
	
	
- (void)switchViewsActual:(id)sender withChoice:(int)which
{
		
	//UIRoundedRectButton
	BOOL result= [self.performViewController noTouches]; 
	
	if(result) {
		
	if ( (which==1) && (self.editPresetViewController == nil))
	{
		EditPresetViewController *controller = [[EditPresetViewController alloc] 
												  initWithNibName:@"EditPresetView" bundle:nil];
		
		controller->currentpreset = performViewController->currentpreset; 
		
		self.editPresetViewController = controller;
		[controller release];
	}
	
	if ( (which==2) && (self.editBankViewController == nil))
	{
			EditBankViewController *controller = [[EditBankViewController alloc] 
													initWithNibName:@"EditBankView" bundle:nil];
			self.editBankViewController = controller;
			[controller release];
	}	
		
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	UIViewController *coming = nil;
	UIViewController *going = nil;
	UIViewAnimationTransition transition;
	
	if (onwhich == 0) { //ie on base view
		
		if (which==1)
			coming = editPresetViewController;
		else 
			coming = editBankViewController;
		
		going = performViewController;
		
		onwhich = which; 
		
		//setTitle:(NSString *)title forState:(UIControlState)
		[sender setTitle:@"perform" forState:UIControlStateNormal]; 
		
	}
	else if (onwhich == 1){
		
		
		going = editPresetViewController;
		
		if (which==1) {
			coming = performViewController;
			onwhich = 0;
			
			[sender setTitle:@"edit" forState:UIControlStateNormal];
		}
		else {
			coming = editBankViewController;
			onwhich = 2;
			
			[leftbutton setTitle:@"edit" forState:UIControlStateNormal];
			[rightbutton setTitle:@"perform" forState:UIControlStateNormal];
		}
		
		
		
	}
	else if (onwhich == 2){
		
		going = editBankViewController;
		
		if (which==2) {
			coming = performViewController;	
			onwhich = 0;
			
			[sender setTitle:@"bank" forState:UIControlStateNormal];
		}
		else {
			coming = editPresetViewController;
			onwhich = 1;
			
			[leftbutton setTitle:@"perform" forState:UIControlStateNormal];
			[rightbutton setTitle:@"bank" forState:UIControlStateNormal];
		}
		
	}
		
		
		
//		
//	if (self.performViewController.view.superview == nil) 
//	{	
//		coming = performViewController;
//		
//		if (which==0)
//		 going = editPresetViewController;
//		else 
//		 going = editBankViewController;
//			
//		transition = UIViewAnimationTransitionFlipFromLeft;
//	}
//	else
//	{
//		if (which==0)
//		 coming = editPresetViewController;
//		else 
//		 coming = editBankViewController;
//		
//		going = performViewController;
//		transition = UIViewAnimationTransitionFlipFromRight;
//	}

		
	if (which==1)
		[editPresetViewController updateFromPreset]; 
	
	//returning to perform view, update	synthesis engine
	if (which==0) {
			
		//CopyToGendynSynthesis
		//gendynpresets_
		//	performViewController->audio= audio; 
		int nowindex= performViewController->currentpresetindex;
		for (int i=0; i<NUMBEROFGENDYNS; ++i) {
			gendynpresets_[nowindex]->CopyToGendynSynthesis(audio->mGendyn[i]);
		}
		
		
		//performViewController->currentpresetindex; // = 0;
		//controller->currentpreset = gendynpresets_[0]; 
		
		
	}
		transition = UIViewAnimationTransitionFlipFromLeft;	
		
	[UIView setAnimationTransition: transition forView:self.view cache:YES];
	[coming viewWillAppear:YES];
	[going viewWillDisappear:YES];
	[going.view removeFromSuperview];
	[self.view insertSubview: coming.view atIndex:0];
	[going viewDidDisappear:YES];
	[coming viewDidAppear:YES];
	
	[UIView commitAnimations];
	
	}
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	
	[audio closeDownAudioDevice];
	[audio freeData];
	[audio release]; 
	
	[editPresetViewController release];
	[editBankViewController release];
	[performViewController release];
	
	[leftbutton release];
	[rightbutton release];
	
	for (int i=0; i<NUMPRESETS; ++i) 
	delete gendynpresets_[i]; 
	
	//make sure timer stopped
	[timer invalidate]; 
	[timer release]; 
	[super dealloc];
}

@end
