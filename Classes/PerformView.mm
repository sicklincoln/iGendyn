//
//  PerformView.m
//  iGendyn
//
//  Created by Nicholas Collins on 23/05/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import "PerformView.h"


@implementation PerformView

//when loading from NIB, initWithFrame not called! 
- (void)awakeFromNib {

	
	//NSLog(@"init Perform View!");
	
	for (int i=0; i<NUMBEROFGENDYNS; ++i) { 
		
		x[i]=0.0; //160.0; 
		y[i]= 0.0; //240.0; 
		on[i]= 0; 
		
	}
	
}

//
//- (id)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        // Initialization code
//		
//	
//		
//		
//    }
//    return self;
//}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	//NSLog(@"drawing code!");
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 3);
	
	for (int i=0; i<NUMBEROFGENDYNS; ++i) { 
		
		if (on[i]) {
			
			int xpos = x[i]*PERFORMXSIZEFLOAT; 
			int ypos = y[i]*PERFORMYSIZEFLOAT; 
			
			//[[UIColor blueColor] set];
			
			CGRect    myFrame; 
			
			//CGRect    myFrame = CGRectMake(xpos-10,ypos-10,20,20); //self.bounds;  //460 or 430? 
			
			//UIRectFill(myFrame); //UIRectFrame
			
			
			//random colour each time? 		
			
			[[UIColor colorWithRed:0.2f green:0.7f blue:0.5f alpha: 0.8f] set];
			
			myFrame = CGRectMake(xpos-10,ypos-2,20,4); //self.bounds;  //460 or 430? 
			
			UIRectFill(myFrame); //UIRectFrame
			
			myFrame = CGRectMake(xpos-2,ypos-10,4,20); //self.bounds;  //460 or 430? 
			
			UIRectFill(myFrame); //UIRectFrame
			
			//	if(on) {
			
			[[UIColor colorWithRed:0.5f green:0.1f blue:1.0f alpha: 0.6f] set];  //old[[UIColor colorWithRed:0.5f green:0.3f blue:1.0f alpha: 0.5f] set];
			
			//don't have line from centre
			//	CGContextMoveToPoint(context, 160.0f, 240.0f); 
			//	CGContextAddLineToPoint(context, xpos, ypos); 
			//	CGContextStrokePath(context);
			
			CGContextMoveToPoint(context, 0.0f, 0.0f); 
			CGContextAddLineToPoint(context, xpos, ypos); 
			CGContextStrokePath(context);
			
			CGContextMoveToPoint(context, 0.0f, PERFORMYSIZEFLOAT); 
			CGContextAddLineToPoint(context, xpos, ypos); 
			CGContextStrokePath(context);
			
			CGContextMoveToPoint(context, PERFORMXSIZEFLOAT, 0.0f); 
			CGContextAddLineToPoint(context, xpos, ypos); 
			CGContextStrokePath(context);
			
			CGContextMoveToPoint(context, PERFORMXSIZEFLOAT, PERFORMYSIZEFLOAT); 
			CGContextAddLineToPoint(context, xpos, ypos); 
			CGContextStrokePath(context);
			
			[[UIColor colorWithRed:0.5f green:0.3f blue:1.0f alpha: 0.2f] set];
			
			//don't have line from centre
			//	CGContextMoveToPoint(context, 160.0f, 240.0f); 
			//	CGContextAddLineToPoint(context, xpos, ypos); 
			//	CGContextStrokePath(context);
			
			CGContextMoveToPoint(context, xpos, 0.0f); 
			CGContextAddLineToPoint(context, xpos, ypos); 
			CGContextStrokePath(context);
			
			CGContextMoveToPoint(context, xpos, PERFORMYSIZEFLOAT); 
			CGContextAddLineToPoint(context, xpos, ypos); 
			CGContextStrokePath(context);
			
			CGContextMoveToPoint(context, 0.0, ypos); 
			CGContextAddLineToPoint(context, xpos, ypos); 
			CGContextStrokePath(context);
			
			CGContextMoveToPoint(context, PERFORMXSIZEFLOAT, ypos); 
			CGContextAddLineToPoint(context, xpos, ypos); 
			CGContextStrokePath(context);
			
			
			
			
			//NSLog(@"DISPLAYING %f %f \n",x,y);
		}
		
	}
	
}


- (void)dealloc {
    [super dealloc];
}


@end
