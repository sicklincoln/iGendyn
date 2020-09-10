//
//  iGendynAppDelegate.m
//  iGendyn
//
//  Created by Nicholas Collins on 22/05/2010.
//  Copyright Nicholas M Collins 2010. All rights reserved.
//

#import "iGendynAppDelegate.h"
#import "SwitchViewController.h"



@implementation iGendynAppDelegate

@synthesize window;
@synthesize switchViewController;





- (void)applicationDidFinishLaunching:(UIApplication *)application {

    //register for notifications of audio interruption 
    
    
    
    // Override point for customization after application launch
	
    self.window.rootViewController = switchViewController;
    //self.window.rootViewController.view = glView; // MUST SET THIS UP OTHERWISE
    
    [window addSubview:switchViewController.view]; 
	[window makeKeyAndVisible];
}


- (void)dealloc {

    [window release];
	[switchViewController release];
    [super dealloc];
}


@end
