//
//  EditBankViewController.h
//  iGendyn
//
//  Created by Nicholas Collins on 10/07/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditBankViewController : UIViewController {

//	IBOutlet UIButton savebutton_; 
//	IBOutlet UIButton loadbutton_; 
//	IBOutlet UIButton loaddefaultbutton_; 
//	IBOutlet UIButton randomizebankbutton_; 
	//UISegmentedControl
	IBOutlet UISegmentedControl *bankSegmentedControl_; 
	
	int whichbank;
	NSUInteger numbanks_;
	//save and load locations
	char ** paths_; 
	BOOL microphonepluggedinatstart_; 
	BOOL saveloadflag_;
	
}

-(void)initPathNames; 

-(IBAction) moreappsinfo:(id)sender;  
-(IBAction) musicinformaticsinfo:(id)sender;  
-(IBAction) save:(id)sender;  
-(IBAction) load:(id)sender;  
-(IBAction) randomizebank:(id)sender;  
-(IBAction) defaultbank:(id)sender;  
-(IBAction) onepresetperfinger:(id)sender;  
-(IBAction) choosebank:(id)sender; 



@end


