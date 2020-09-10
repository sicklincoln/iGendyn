//
//  PerformViewController.m
//  iGendyn
//
//  Created by Nicholas Collins on 22/05/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import "PerformViewController.h"
#import "PerformView.h"

@implementation PerformViewController

@synthesize motionManager;

#define kAccelerometerFrequency     30



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
		//keeping track of active touches and their influence on gendyn 
		mActiveTouches=0; 
		for(int i=0; i<NUMBEROFGENDYNS; ++i) 
			mTouchAddresses[i]= NULL; 
		
	
    }
    return self;
}


- (void)setupaccelerometer {
		
    motionManager = [[CMMotionManager alloc] init];
    
    [self startMyMotionDetect];
    
    
	
//	UIAccelerometer * accel= [UIAccelerometer sharedAccelerometer];
//	
//	//avoiding this for now for safety; app keeps crashing! 
//	[accel setUpdateInterval:(1.0 / kAccelerometerFrequency)];
//	
//	[accel setDelegate:self]; 	
//	
	
}




//http://thirdcog.eu/pwcblocks/#whatareblocks

- (void)startMyMotionDetect
{
    
    //__block float stepMoveFactor = 15;
    
    [self.motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         
         //data.acceleration.x;
         
         [self accelerometerChange:data.acceleration];
         
         //if calling GUI
//         dispatch_async(dispatch_get_main_queue(),
//                        ^{
//                            
//                        }
//                        );

     }
     ];
    
}





-(BOOL)noTouches {
	
	BOOL output = YES; 
	
	if(mActiveTouches>0) output= NO; 
	
//	for (int i=0; i<NUMBEROFGENDYNS; ++i) 
//		if(mTouchAddresses[i]) { output= NO; break; }
	
	return output; 
}




/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
 

	 
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


- (void)dealloc {
    
    [self.motionManager stopAccelerometerUpdates];
    
    [super dealloc];
}






//passed this message I hope from 

// UIAccelerometerDelegate method, called when the device accelerates.
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    
- (void)accelerometerChange:(CMAcceleration)acceleration {
    
    // Update the accelerometer graph view
    //[graphView updateHistoryWithX:acceleration.x Y:acceleration.y Z:acceleration.z];
	
	//values x,y,z are doubles
	//printf("x %f y %f z %f \n", acceleration.x,acceleration.y,acceleration.z);
	//NSLog(@"x %f y %f z %f \n", acceleration.x,acceleration.y,acceleration.z);
	//NSLog( @"Record %d is %@", recNum, recName );
	
	//float normx= ((acceleration.x+2.5)/5.0);
	
	float normx= ((acceleration.x+1.0)/2.0);
	
	
	if(normx<0.0) normx=0.0;
	if(normx>1.0) normx=1.0;
	
	float normz= ((acceleration.z+2.5)/5.0);
	
	if(normz<0.0) normz=0.0;
	if(normz>1.0) normz=1.0;
	
	//float normy= ((acceleration.y+2.5)/5.0);
	
	float normy= ((acceleration.y+1.0)/2.0);
	
	
	if(normy<0.0) normy=0.0;
	if(normy>1.0) normy=1.0;
	
	
	//if(accelactive) {
	
	for (int i=0; i<NUMBEROFGENDYNS; ++i) {
		GendynSynthesis	* pgendyn=  audio->mGendyn[i]; 	
				
		currentpreset->UpdateGendynSynthesis(pgendyn, 2, normx);
		currentpreset->UpdateGendynSynthesis(pgendyn, 3, normy);
		currentpreset->UpdateGendynSynthesis(pgendyn, 4, normz);
		
		
		//DEBUG tests:
		//pgendyn->maxfreq =pgendyn->minfreq + (2000.0*normy); //avoid going too fast
//		
//		pgendyn->scaleamp= normx;
//		pgendyn->scaledur= normx;
//		
//		pgendyn->lehmera= normy;
//		pgendyn->lehmerc= normz;
//		
	}
		
	//}
	
	//	mGendyn.aamp= normx;
	//	mGendyn.adur= normy;
	
//	if(mGendynReady) {
		
//		for (int i=0; i<NUMBEROFGENDYNS; ++i) 
//		{
//			GendynSynthesis	* pgendyn=  mGendyn[i]; 	
//			
//			//pgendyn->maxfreq =pgendyn->minfreq + (2000.0*normz); 
//			
//			//pgendyn->maxfreq =pgendyn->minfreq + (1000.0*normz); 
//			
//			pgendyn->maxfreq =pgendyn->minfreq + (2000.0*normy); //avoid going too fast
//			
//			pgendyn->scaleamp= normx;
//			pgendyn->scaledur= normx;
//			
//			pgendyn->lehmera= normy;
//			pgendyn->lehmerc= normz;
//			
//			//pgendyn->aamp= normz;
//			//pgendyn->adur= normz;
//			
//			//mGendyn->maxfreq= mGendyn->minfreq + (normz*500.0);
//		}
		//	
//	}
	
	//NSLog(@"x %f y %f z %f \n", normx,normy,normz);
	
	
	//	int whichamp= (int)ZIN0(0);
	//	int whichdur= (int)ZIN0(1);
	//	float aamp = ZIN0(2);
	//	float adur = ZIN0(3);
	//	float minfreq = ZIN0(4);
	//	float maxfreq = ZIN0(5);
	//	float scaleamp = ZIN0(6);
	//	float scaledur = ZIN0(7); 
	//	
	
}




//touches are those new ones pressed down, want all active right now? 
//override UIResponder  UIViewController is derived from it
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	int i; 
	
	//NSSet *touches = [[event allTouches] anyObject];
	
	//[event allTouches]
	
	//NO, this is all active touches not those that just began
	//NSArray *arrayt = [[event allTouches] allObjects];
	//NSUInteger num= [arrayt count];
	
	//NSUInteger num= [touches count]; 
	
	PerformView * mainview= (PerformView *)[self view]; 
	CGPoint touchPoint; 
	float x, y; 
	
	//int pos= 0; 
	
	for ( UITouch* touch in touches ) {
		
		if (mActiveTouches< NUMBEROFGENDYNS) {
			
			//search for first non NULL slot 
			
			int nextfreeslot=0; 
			
			for (i=NUMBEROFGENDYNS-1; i>=0; --i) 
				if(mTouchAddresses[i]==NULL) nextfreeslot = i; 
			
			mTouchAddresses[nextfreeslot] = (void*) touch; 
			++mActiveTouches; 
			
			touchPoint = [touch locationInView:[self view]];
			
			//printf("x %f y %f \n",touchPoint.x, touchPoint.y);
			
			x= (touchPoint.x)/PERFORMXSIZEFLOAT; 
			y= (touchPoint.y)/PERFORMYSIZEFLOAT; 
			
			if(x>1.0) x= 1.0; 
			if(y>1.0) y= 1.0; 
			
			//float; need to be one for each 
			mainview->x[nextfreeslot]= x; 
			mainview->y[nextfreeslot]= y; 
			
			GendynSynthesis * pgendy= audio->mGendyn[nextfreeslot]; 
			
			currentpreset->UpdateGendynSynthesis(pgendy, 0, x);
			currentpreset->UpdateGendynSynthesis(pgendy, 1, y);
			
			
			
			pgendy->running=1; 
			pgendy->juststarted=1; 
			
			//NSLog(@"i %d x %f y %f \n",i, x,y);
			
			//NUMBEROFGENDYNS
			//GendynSynthesis * pgendy= player->mGendyn[nextfreeslot]; 
//			
//			pgendy->mAmplitude = x*x; //y*y; //adur
//			pgendy->minfreq = (y*1000.0); //100.0+
//			//pgendy->maxfreq =pgendy->minfreq + (2000.0*pgendy->mAmplitude); 
//			
//			pgendy->running=1; 
//			pgendy->juststarted=1; 
			
			mainview->on[nextfreeslot]= 1;
			
		}
		
	}
	
	//pass to RootViewController via RootView to check for double click and making info button
	//[[[self view] superview] touchesBegan:touches withEvent:event];
	
	//[mainview setNeedsDisplay]; 
	
	
		
	
}






- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	PerformView * mainview= (PerformView *)[self view]; 
	CGPoint touchPoint; 
	float x, y; 
	
	//int pos= 0; 
	
	for ( UITouch* touch in touches ) {
		
		for (int i=0; i<NUMBEROFGENDYNS; ++i) {
			
			//if same object, update it	
			if (mTouchAddresses[i]== (void *)touch) {
				
				touchPoint = [touch locationInView:[self view]];
				
				//printf("x %f y %f \n",touchPoint.x, touchPoint.y);
				
				x= (touchPoint.x)/PERFORMXSIZEFLOAT; 
				y= (touchPoint.y)/PERFORMYSIZEFLOAT; 
                
                //NSLog(@"x %f y %f mainx %f mainy %f \n",x,y, mainview->x[i], mainview->y[i]);
				
				if(x>1.0) x= 1.0; 
				if(y>1.0) y= 1.0; 
				
				//if moved sufficiently from the current position
				if ((fabs(mainview->x[i]-x) + fabs(mainview->y[i]-y)) > 0.000001) {
					
					//float; need to be one for each 
					mainview->x[i]= x; 
					mainview->y[i]= y; 
					
					GendynSynthesis * pgendy= audio->mGendyn[i]; 
					
					currentpreset->UpdateGendynSynthesis(pgendy, 0, x);
					currentpreset->UpdateGendynSynthesis(pgendy, 1, y);
					
					pgendy->running=1; 
					
					//NSLog(@"i %d x %f y %f \n",i, x,y);
				//	
//					//NUMBEROFGENDYNS
//					GendynSynthesis * pgendy= player->mGendyn[i]; 
//					
//					
//					pgendy->mAmplitude = x*x; //y*y; //adur
//					pgendy->minfreq = (y*1000.0); //100.0+
//					//pgendy->maxfreq =pgendy->minfreq + (2000.0*pgendy->mAmplitude); 
//					
//					//pgendy->mAmplitude = y*y; //adur
//					//			pgendy->minfreq = 100.0+(x*1000.0);
//					//			pgendy->maxfreq =pgendy->minfreq + (2000.0*pgendy->mAmplitude); 
//					//			
//					//pgendy->running=1; 
//					
//					//could be set multiple times, but hey, shouldn't affect it? 		
//					[mainview setNeedsDisplay]; 
				}
				//mainview->on[i]= 1;
				
			}
			
		}
		
	}
	
	
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	PerformView * mainview= (PerformView *)[self view]; 
	
	for ( UITouch* touch in touches ) {
		
		for (int i=0; i<NUMBEROFGENDYNS; ++i) {
			
			//if same object, update it	
			if (mTouchAddresses[i]== (void *)touch) {
				
			//	//NUMBEROFGENDYNS
//				GendynSynthesis * pgendy= player->mGendyn[i]; 
//				
//				//should fade out and fade in? go with brutal for now...
//				
//				pgendy->running=0; 
//				pgendy->justended=1;
				
				
				GendynSynthesis * pgendy= audio->mGendyn[i]; 
				
				//currentpreset->UpdateGendynSynthesis(pgendy, 0, x);
				//currentpreset->UpdateGendynSynthesis(pgendy, 1, y);
				
				pgendy->running=0; 
				pgendy->justended=1; 
				
				mainview->on[i]= 0;	
				
				mTouchAddresses[i] = NULL; 
				--mActiveTouches;
                //NSLog(@"num touches now %d\n",mActiveTouches);
				
				//[mainview setNeedsDisplay];
				//mainview->on[i]= 1;
				
			}
			
		}
		
	}
	
	
	
}



//for safety, look out for this too
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	PerformView * mainview= (PerformView *)[self view]; 
	
	for ( UITouch* touch in touches ) {
		
		for (int i=0; i<NUMBEROFGENDYNS; ++i) {
			
			//if same object, update it	
			if (mTouchAddresses[i]== (void *)touch) {
				
				//NUMBEROFGENDYNS
			//	GendynSynthesis * pgendy= player->mGendyn[i]; 
//				
//				//should fade out and fade in? go with brutal for now...
//				
//				pgendy->running=0; 
//				pgendy->justended=1;
				
				
				GendynSynthesis * pgendy= audio->mGendyn[i]; 
				
				//currentpreset->UpdateGendynSynthesis(pgendy, 0, x);
				//currentpreset->UpdateGendynSynthesis(pgendy, 1, y);
				
				pgendy->running=0; 
				pgendy->justended=1; 
				
				mainview->on[i]= 0;	
				
				mTouchAddresses[i] = NULL; 
				--mActiveTouches; 
				
				//[mainview setNeedsDisplay];
				//mainview->on[i]= 1;
				
			}
			
		}
		
	}
	
	
}




@end
