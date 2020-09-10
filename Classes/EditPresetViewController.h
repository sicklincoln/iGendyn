//
//  EditPresetViewController.h
//  iGendyn
//
//  Created by Nicholas Collins on 22/05/2010.
//  Copyright 2010 Nicholas M Collins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GendynPreset.h"

@interface EditPresetViewController : UIViewController {

@public
	IBOutlet UIScrollView *scrollview;
	
	IBOutlet UISegmentedControl *algorithmsegment; 
	
	IBOutlet UISegmentedControl *amplitudesegment; 
	IBOutlet UISlider *amplitudeslider;
	IBOutlet UILabel *amplitudelabel;
	
	
	IBOutlet UISegmentedControl *whichampmapping; 
	IBOutlet UISegmentedControl *whichampsegment; 
	
	IBOutlet UISegmentedControl *whichdurmapping; 
	IBOutlet UISegmentedControl *whichdursegment; 
	
	
	IBOutlet UISegmentedControl *aampmapping; 
	IBOutlet UISlider *aampslider;
	IBOutlet UILabel *aamplabel;

	
	IBOutlet UISegmentedControl *adurmapping; 
	IBOutlet UISlider *adurslider;
	IBOutlet UILabel *adurlabel;
	
	
	IBOutlet UISegmentedControl *minfreqmapping; 
	IBOutlet UISlider *minfreqslider;
	IBOutlet UILabel *minfreqlabel;
	
	IBOutlet UISegmentedControl *maxfreqmapping; 
	IBOutlet UISlider *maxfreqslider;
	IBOutlet UILabel *maxfreqlabel;

	
	IBOutlet UISegmentedControl *scaleampmapping; 
	IBOutlet UISlider *scaleampslider;
	IBOutlet UILabel *scaleamplabel;
	
	IBOutlet UISegmentedControl *scaledurmapping; 
	IBOutlet UISlider *scaledurslider;
	IBOutlet UILabel *scaledurlabel;
	
	IBOutlet UISegmentedControl *activeCPsmapping; 
	IBOutlet UISlider *activeCPsslider;
	IBOutlet UILabel *activeCPslabel;
	
	IBOutlet UISegmentedControl *lehmeramapping; 
	IBOutlet UISlider *lehmeraslider;
	IBOutlet UILabel *lehmeralabel;
	
	IBOutlet UISegmentedControl *lehmercmapping; 
	IBOutlet UISlider *lehmercslider;
	IBOutlet UILabel *lehmerclabel;
//	
//	IBOutlet UISegmentedControl *mapping; 
//	IBOutlet UISlider *slider;
//	IBOutlet UILabel *label;
	
	GendynPreset * currentpreset; 
	int currentpresetindex; 
	
}

@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;

@property(nonatomic,retain) IBOutlet UISegmentedControl *algorithmsegment; 
@property(nonatomic,retain) IBOutlet UISegmentedControl *amplitudesegment; 
@property(nonatomic,retain) IBOutlet UISlider *amplitudeslider;
@property(nonatomic,retain) IBOutlet UILabel *amplitudelabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *whichampmapping; 
@property(nonatomic,retain) IBOutlet UISegmentedControl *whichampsegment; 
@property(nonatomic,retain) IBOutlet UISegmentedControl *whichdurmapping; 
@property(nonatomic,retain) IBOutlet UISegmentedControl *whichdursegment; 
@property(nonatomic,retain) IBOutlet UISegmentedControl *aampmapping; 
@property(nonatomic,retain) IBOutlet UISlider *aampslider;
@property(nonatomic,retain) IBOutlet UILabel *aamplabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *adurmapping; 
@property(nonatomic,retain) IBOutlet UISlider *adurslider;
@property(nonatomic,retain) IBOutlet UILabel *adurlabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *minfreqmapping; 
@property(nonatomic,retain) IBOutlet UISlider *minfreqslider;
@property(nonatomic,retain) IBOutlet UILabel *minfreqlabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *maxfreqmapping; 
@property(nonatomic,retain) IBOutlet UISlider *maxfreqslider;
@property(nonatomic,retain) IBOutlet UILabel *maxfreqlabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *scaleampmapping; 
@property(nonatomic,retain) IBOutlet UISlider *scaleampslider;
@property(nonatomic,retain) IBOutlet UILabel *scaleamplabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *scaledurmapping; 
@property(nonatomic,retain) IBOutlet UISlider *scaledurslider;
@property(nonatomic,retain) IBOutlet UILabel *scaledurlabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *activeCPsmapping; 
@property(nonatomic,retain) IBOutlet UISlider *activeCPsslider;
@property(nonatomic,retain) IBOutlet UILabel *activeCPslabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *lehmeramapping; 
@property(nonatomic,retain) IBOutlet UISlider *lehmeraslider;
@property(nonatomic,retain) IBOutlet UILabel *lehmeralabel;
@property(nonatomic,retain) IBOutlet UISegmentedControl *lehmercmapping; 
@property(nonatomic,retain) IBOutlet UISlider *lehmercslider;
@property(nonatomic,retain) IBOutlet UILabel *lehmerclabel;



//update whole GUI control state based on preset to be edited
-(void) updateFromPreset; 

-(IBAction) changealgorithm:(id)sender; 

-(IBAction) changeamplitudemapping:(id)sender; 
-(IBAction) changeamplitudevalue:(id)sender; 

-(IBAction) changewhichampmapping:(id)sender; 
-(IBAction) changewhichampvalue:(id)sender; 

-(IBAction) changewhichdurmapping:(id)sender; 
-(IBAction) changewhichdurvalue:(id)sender; 

-(IBAction) changeaamp:(id)sender; 
-(IBAction) changeaampmapping:(id)sender; 

-(IBAction) changeadur:(id)sender; 
-(IBAction) changeadurmapping:(id)sender; 

-(IBAction) changeminfreq:(id)sender; 
-(IBAction) changeminfreqmapping:(id)sender; 

-(IBAction) changemaxfreq:(id)sender; 
-(IBAction) changemaxfreqmapping:(id)sender; 

-(IBAction) changescaleamp:(id)sender; 
-(IBAction) changescaleampmapping:(id)sender; 

-(IBAction) changescaledur:(id)sender; 
-(IBAction) changescaledurmapping:(id)sender; 

-(IBAction) changeactiveCPs:(id)sender; 
-(IBAction) changeactiveCPsmapping:(id)sender; 

-(IBAction) changelehmera:(id)sender; 
-(IBAction) changelehmeramapping:(id)sender; 

-(IBAction) changelehmerc:(id)sender; 
-(IBAction) changelehmercmapping:(id)sender; 

//-(IBAction) change:(id)sender; 
//-(IBAction) changemapping:(id)sender; 



@end
