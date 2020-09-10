//
//  EditPresetViewController.m
//  iGendyn
//
//  Created by Nicholas Collins on 22/05/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import "EditPresetViewController.h"

//for gendynpresets_
#import "SwitchViewController.h"

@implementation EditPresetViewController

@synthesize scrollview,algorithmsegment,amplitudesegment,amplitudeslider,amplitudelabel;
@synthesize whichampmapping,whichampsegment,whichdurmapping,whichdursegment,aampmapping,aampslider,aamplabel;
@synthesize adurmapping,adurslider,adurlabel,minfreqmapping,minfreqslider,minfreqlabel,maxfreqmapping,maxfreqslider,maxfreqlabel,scaleampmapping,scaleampslider,scaleamplabel,scaledurmapping,scaledurslider,scaledurlabel,activeCPsmapping,activeCPsslider,activeCPslabel,lehmeramapping,lehmeraslider,lehmeralabel,lehmercmapping,lehmercslider,lehmerclabel;

//http://stackoverflow.com/questions/1040519/iphone-sdk-how-can-i-add-a-scroll-view-to-my-application
//ScrollView


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
    [super viewDidLoad];
	
	//UIScrollView *tempScrollView=(UIScrollView *)self.view;
	//must set this to BIGGER than the source view in IB. Resize in IB, add subviews, then resize back to hide them!  
    scrollview.contentSize=CGSizeMake(320,1300);
	
	
	[self updateFromPreset];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



-(void) updateFromPreset {
		
	algorithmsegment.selectedSegmentIndex = currentpreset->algorithm;  
	
	amplitudesegment.selectedSegmentIndex = currentpreset->controlflags[0]; 
	
	amplitudeslider.value = currentpreset->amplitude;
	
	amplitudelabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->amplitude];
	
	whichampsegment.selectedSegmentIndex = currentpreset->whichamp ;
	
	whichampmapping.selectedSegmentIndex = currentpreset->controlflags[1]; 
	
	whichdursegment.selectedSegmentIndex = currentpreset->whichdur;
	
	whichdurmapping.selectedSegmentIndex = currentpreset->controlflags[2]; 
	
	//mapping.selectedSegmentIndex = currentpreset->controlflags[0]; 
//	
//	slider.value = currentpreset->;
//	
//	label.text = [NSString stringWithFormat:@"%1.2f",currentpreset->];
//	
//	
	
	aampmapping.selectedSegmentIndex = currentpreset->controlflags[3]; 
	
	aampslider.value = currentpreset->aamp;
	
	aamplabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->aamp];
	
	
	adurmapping.selectedSegmentIndex = currentpreset->controlflags[4]; 
	
	adurslider.value = currentpreset->adur;
	
	adurlabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->adur];
	
	
	minfreqmapping.selectedSegmentIndex = currentpreset->controlflags[5]; 
	
	minfreqslider.value = currentpreset->minfreq/1000.0;
	
	minfreqlabel.text = [NSString stringWithFormat:@"%4.1f",currentpreset->minfreq];
	
	maxfreqmapping.selectedSegmentIndex = currentpreset->controlflags[6]; 
	
	maxfreqslider.value = currentpreset->maxfreq/2000.0;
	
	maxfreqlabel.text = [NSString stringWithFormat:@"%4.1f",currentpreset->maxfreq];
	
	scaleampmapping.selectedSegmentIndex = currentpreset->controlflags[7]; 
	
	scaleampslider.value = currentpreset->scaleamp;
	
	scaleamplabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->scaleamp];
	
	scaledurmapping.selectedSegmentIndex = currentpreset->controlflags[8]; 
	
	scaledurslider.value = currentpreset->scaledur;
	
	scaledurlabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->scaledur];

	activeCPsmapping.selectedSegmentIndex = currentpreset->controlflags[9]; 
	
	activeCPsslider.value = ((currentpreset->activeCPs)-1)/8.999999;
	
	activeCPslabel.text = [NSString stringWithFormat:@"%d",currentpreset->activeCPs];

	
	lehmeramapping.selectedSegmentIndex = currentpreset->controlflags[10]; 
	
	lehmeraslider.value = currentpreset->lehmera*0.5;
	
	lehmeralabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->lehmera*0.5];
	
	lehmercmapping.selectedSegmentIndex = currentpreset->controlflags[11]; 
	
	lehmercslider.value = currentpreset->lehmerc*0.25;
	
	lehmerclabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->lehmerc*0.25];
	
	
	
}




-(IBAction) changealgorithm:(id)sender {
	
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	//if([self.performViewController noTouches]) {
//		
//		int choice = [segment selectedSegmentIndex]; 
	
	currentpreset->algorithm = [segment selectedSegmentIndex];  
	
}

-(IBAction) changeamplitudemapping:(id)sender {
	
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[0] = [segment selectedSegmentIndex]; 
}

-(IBAction) changeamplitudevalue:(id)sender {
	
	float input = [amplitudeslider value]; 
	
	currentpreset->amplitude = input*input; 

	amplitudelabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->amplitude];
	
}



-(IBAction) changewhichampmapping:(id)sender {
	
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[1] = [segment selectedSegmentIndex]; 
	
}

-(IBAction) changewhichampvalue:(id)sender{
	
	currentpreset->whichamp = [whichampsegment selectedSegmentIndex];
	
//	float input = [whichampslider value]; 
//	
//	currentpreset->whichamp = (int)(5.999999*input);
//	
	//amplitudelabel.text = [NSString stringWithFormat:@"%d",currentpreset->whichamp];
	
	
} 

-(IBAction) changewhichdurmapping:(id)sender{

	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[2] = [segment selectedSegmentIndex]; 
	
}

-(IBAction) changewhichdurvalue:(id)sender{
	
	//float input = [whichdurslider value]; 
	//UISegmentedControl * segment = (UISegmentedControl *)sender; 
	currentpreset->whichdur = [whichdursegment selectedSegmentIndex]; //(int)(input*5.999999); 
	
	//amplitudelabel.text = [NSString stringWithFormat:@"%d",currentpreset->whichamp];
	
} 

-(IBAction) changeaamp:(id)sender{
	
	float input = [aampslider value]; 
	
	currentpreset->aamp = input; 
	
	aamplabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->aamp];
	
} 

-(IBAction) changeaampmapping:(id)sender{
	
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[3] = [segment selectedSegmentIndex]; 
	
} 

-(IBAction) changeadur:(id)sender{
		
	float input = [adurslider value]; 
	
	currentpreset->adur = input; 
	
	adurlabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->adur];
	
} 

-(IBAction) changeadurmapping:(id)sender{
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[4] = [segment selectedSegmentIndex]; 
}


-(IBAction) changeminfreq:(id)sender{

	float input = [minfreqslider value]; 
	
	currentpreset->minfreq = input*1000.0; 
	
	minfreqlabel.text = [NSString stringWithFormat:@"%4.1f",currentpreset->minfreq];
	
} 

-(IBAction) changeminfreqmapping:(id)sender{
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[5] = [segment selectedSegmentIndex]; 
} 

-(IBAction) changemaxfreq:(id)sender{
	float input = [maxfreqslider value]; 
	
	currentpreset->maxfreq = 2000.0*input; 
	
	maxfreqlabel.text = [NSString stringWithFormat:@"%4.1f",currentpreset->maxfreq];	
} 

-(IBAction) changemaxfreqmapping:(id)sender{
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[6] = [segment selectedSegmentIndex]; 
} 

-(IBAction) changescaleamp:(id)sender{
	float input = [scaleampslider value]; 
	
	currentpreset->scaleamp = input; 
	
	scaleamplabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->scaleamp];
	
} 

-(IBAction) changescaleampmapping:(id)sender{
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[7] = [segment selectedSegmentIndex]; 
} 


-(IBAction) changescaledur:(id)sender{

	float input = [scaledurslider value]; 
	
	currentpreset->scaledur = input; 
	
	scaledurlabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->scaledur];
	
} 

-(IBAction) changescaledurmapping:(id)sender{
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[8] = [segment selectedSegmentIndex]; 
} 

-(IBAction) changeactiveCPs:(id)sender{
	
	float input = [activeCPsslider value]; 
	
	currentpreset->activeCPs = ((int)(input*8.999999)) + 1;
	
	activeCPslabel.text = [NSString stringWithFormat:@"%d",currentpreset->activeCPs];
	
}

-(IBAction) changeactiveCPsmapping:(id)sender{
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[9] = [segment selectedSegmentIndex]; 
} 

-(IBAction) changelehmera:(id)sender{

	float input = [lehmeraslider value]; 
	
	currentpreset->lehmera = 2.0*input; 
	
	lehmeralabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->lehmera];
	
	
}

-(IBAction) changelehmeramapping:(id)sender{
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[10] = [segment selectedSegmentIndex]; 
} 

-(IBAction) changelehmerc:(id)sender{
	
	float input = [lehmercslider value]; 
	
	currentpreset->lehmerc = 4.0*input; 
	
	lehmerclabel.text = [NSString stringWithFormat:@"%1.2f",currentpreset->lehmerc];
	
} 

-(IBAction) changelehmercmapping:(id)sender{
	
	UISegmentedControl * segment = (UISegmentedControl *)sender; 
	
	currentpreset->controlflags[11] = [segment selectedSegmentIndex]; 
	
} 






- (void)dealloc {
	
	
	[scrollview release];
	[algorithmsegment release];
	[amplitudesegment release];
	[amplitudeslider release];
	[amplitudelabel release];
	
	
	
	[whichampmapping release]; 
	[whichampsegment release]; 
	[whichdurmapping release]; 
	[whichdursegment release]; 
	[aampmapping release]; 
	[aampslider release];
	[aamplabel release];
	[adurmapping release]; 
	[adurslider release];
	[adurlabel release];
	[minfreqmapping release]; 
	[minfreqslider release];
	[minfreqlabel release];
	[maxfreqmapping release]; 
	[maxfreqslider release];
	[maxfreqlabel release];
	[scaleampmapping release]; 
	[scaleampslider release];
	[scaleamplabel release];
	[scaledurmapping release]; 
	[scaledurslider release];
	[scaledurlabel release];
	[activeCPsmapping release]; 
	[activeCPsslider release];
	[activeCPslabel release];
	[lehmeramapping release]; 
	[lehmeraslider release];
	[lehmeralabel release];
	[lehmercmapping release]; 
	[lehmercslider release];
	[lehmerclabel release];
	
    [super dealloc];
}


@end
