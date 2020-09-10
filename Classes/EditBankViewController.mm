    //
//  EditBankViewController.m
//  iGendyn
//
//  Created by Nicholas Collins on 10/07/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import "EditBankViewController.h"


//for gendynpresets_
#import "SwitchViewController.h"


@implementation EditBankViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	saveloadflag_ = NO; 
	
    [super viewDidLoad];
	
	[self initPathNames];
	
	whichbank = 0; 
}



-(void)initPathNames {
	
	int i;
	
	//recordButton_.selected = YES; //starts in record mode
	
	//numpresets_ = presetSegmentedControl_.numberOfSegments;
	
	NSUInteger numsegments= bankSegmentedControl_.numberOfSegments;
	
	self->numbanks_ = numsegments; 
	
	NSArray *systempaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [systempaths objectAtIndex:0];
	
	int directorylength = [documentsDirectory length] + 1; 
	
	char directory[directorylength]; 
	
	//UTF8String
	BOOL check= [documentsDirectory getCString:directory maxLength:directorylength encoding:NSUTF8StringEncoding];
	
	//set up paths
	self->paths_ = new char * [numsegments];
	
	//char temp[] = "Hello"
	
	char numbuf[5];
	
	// convert 123 to string [buf]
	
	char str[directorylength+10];
	
	for (i = 0; i < numsegments; ++i) {
		self->paths_[i] = new char[directorylength+10]; //assume safe size for pathnames
		
		sprintf(numbuf, "%d", i);
		//itoa nonstandard and not available, see http://stackoverflow.com/questions/228005/alternative-to-itoa-for-converting-integer-to-string-c
		//itoa(i, numbuf, 10);
		
		strcpy(str,directory);
		strcat(str,"/bank");
		strcat(str,numbuf);
		
		//printf("%s\n",str);
		
		
		stpcpy(self->paths_[i], str); //destination first
		
		//NSString *stringFromUTFString = [[NSString alloc] initWithUTF8String:str];
		
		//NSLog(@"Pathname: %@ (length %d)", stringFromUTFString, [stringFromUTFString length]);
		
		
	}
	
	
	
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/




-(IBAction) moreappsinfo:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://composerprogrammer.com/iphone.html"]];
}


-(IBAction) musicinformaticsinfo:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://composerprogrammer.com/iphone.html"]];
}

-(IBAction) save:(id)sender {
	
	if(saveloadflag_ == NO) { 
		
		saveloadflag_ = YES; 
		
		
		int which = bankSegmentedControl_.selectedSegmentIndex; //which one? 
		
		//need further flags???
		ofstream myfile(paths_[which],std::ios::out|std::ios::binary); //no point using binary unless make it all read and write, but easier if just make whitespace based with ascii files, std::ios::binary);
		
		if (myfile.is_open()) {
			
			//for each preset
			for (int i=0; i<NUMPRESETS; ++i)
				gendynpresets_[i]->Save(myfile);
			
			myfile.close();
			//NSLog(@"saved to %s",paths_[which]);
			
		}
		
		
		saveloadflag_ = NO; 	
	}
	
	
	
	
}

-(IBAction) load:(id)sender {
	
	
	
	if(saveloadflag_ == NO) { 
		
		saveloadflag_ = YES; 
		
		int which = bankSegmentedControl_.selectedSegmentIndex; //which one? 
		
		ifstream myfile(paths_[which],std::ios::in | std::ios::binary); 
		
		if (myfile.is_open()) {
			
			//for each preset
			for (int i=0; i<NUMPRESETS; ++i)
				gendynpresets_[i]->Load(myfile);
			
			
			//current preset must now update any synthesis process
			
			myfile.close();
			
			//NSLog(@"loaded from %s",paths_[which]);
			
			//update any UI state, ie weightings of features? or only save load the data itself...
			
			//[self setControlsFromConcatSynth];
			
		}
		
		
		saveloadflag_ = NO; 	
	}	
	
	
	
}

-(IBAction) randomizebank:(id)sender {
	
	for (int i=0; i<NUMPRESETS; ++i)
		gendynpresets_[i]->Randomize(); 
		
}

-(IBAction) defaultbank:(id)sender {
	
	gendynpresets_[0]->Default1(); 
	gendynpresets_[1]->Default2(); 
	gendynpresets_[2]->Default3(); 
	
}

//not currently implemented. 
-(IBAction) onepresetperfinger:(id)sender {
	
}

-(IBAction) choosebank:(id)sender {
	
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	int currval= [segment selectedSegmentIndex]; 
	
	whichbank = currval; 
	
}









- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[bankSegmentedControl_ release];
	
	for (int i = 0; i < numbanks_; ++i) {
		delete [] paths_[i];
	}
	
	delete [] paths_;
}


@end
