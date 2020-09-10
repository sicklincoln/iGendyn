//
//  iGendynAppDelegate.h
//  iGendyn
//
//  Created by Nicholas Collins on 22/05/2010.
//  Copyright Nicholas M Collins 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SwitchViewController;

@interface iGendynAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	IBOutlet SwitchViewController *switchViewController; 
	
//@public

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SwitchViewController *switchViewController;

@end

