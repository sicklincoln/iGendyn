/*
 *  GendynPreset.cpp
 *  iGendyn
 *
 *  Created by Nicholas Collins on 24/05/2010.
 *  Copyright 2010 Nicholas M Collins. All rights reserved.
 *
 */

#include "GendynPreset.h"

#include <stdlib.h>

#define frand() 4.6566128752458e-10*(float)rand()

//control flags
//0= x
//1= y
//2= ax
//3= ay
//4= az


GendynPreset::GendynPreset() {

	algorithm=0; //basic 0, hoffmann 1, can't be modulated live
	amplitude = 0.0; 
		
	whichamp= 1;
	whichdur= 1;
	aamp = 1.0;
	adur = 1.0;
	minfreq = 44; //440
	maxfreq = 200; //660
	scaleamp = 0.5;
	scaledur = 0.5; 
	activeCPs = 9; 
	
	lehmera=1.17; 
	lehmerc=0.31;

//	for (int i=0; i<NUMPARAMETERS; ++i)
//		controlflags[i]= 5; //nothing mapped through? 
//	
	//randomisation code for testing
//	for (int i=0; i<NUMPARAMETERS; ++i)
//		controlflags[i]= (int)(4.999*frand());  //if allow 5.99, then get amplitude turned off, etc
//	
//	algorithm=(int)(1.999*frand());
	//controlflags[i]
	
	Randomize(); 
	
}


GendynPreset::~GendynPreset() {

}



void GendynPreset::Randomize() {
	
	for (int i=0; i<NUMPARAMETERS; ++i)
		controlflags[i]= (int)(5.999*frand());  //if allow 5.99, then get amplitude turned off, etc
	
    controlflags[0] = (int)(3.999*frand());; //amplitude must have a control from touch position or accelerometer x or y
    
	algorithm=(int)(1.999*frand());
	amplitude = frand()*frand(); 
	
	if (controlflags[0]==5)
		amplitude= frand()*0.5+0.5;
	
	whichamp = (int)(frand()*5.999999);
	whichdur = (int)(frand()*5.999999); 
	aamp = frand(); 
	adur = frand(); 
	minfreq = frand()*1000.0; 
	maxfreq = minfreq + (2500.0*frand()); 
	//maxfreq = minfreq + (2000.0*frand()); 
	//maxfreq = 3000.0*frand(); 
	scaleamp = frand();
	scaledur = frand();  
	activeCPs = ((int)(frand()*8.999999)) + 1;
	lehmera = frand();//*2.0; 
	lehmerc = frand();//*4.0; 
	
}



void GendynPreset::Save(ostream& out) {
	
	int version=1; 
	
	out.write((char *) &version, sizeof(int));
	out.write((char *) &amplitude, sizeof(float));
	out.write((char *) &algorithm, sizeof(int));
	out.write((char *) &whichamp, sizeof(int));
	out.write((char *) &whichdur, sizeof(int));
	out.write((char *) &aamp, sizeof(float));
	out.write((char *) &adur, sizeof(float));
	out.write((char *) &minfreq, sizeof(float));
	out.write((char *) &maxfreq, sizeof(float));
	out.write((char *) &scaleamp, sizeof(float));
	out.write((char *) &scaledur, sizeof(float));
	out.write((char *) &activeCPs, sizeof(int));
	out.write((char *) &lehmera, sizeof(float));
	out.write((char *) &lehmerc, sizeof(float));
	
	out.write((char *) controlflags, sizeof(int)*NUMPARAMETERS);
	
}

void GendynPreset::Load(istream& in) {
	
	int version=1; 
	
	in.read((char *) &version, sizeof(int));
	in.read((char *) &amplitude, sizeof(float));
	in.read((char *) &algorithm, sizeof(int));
	in.read((char *) &whichamp, sizeof(int));
	in.read((char *) &whichdur, sizeof(int));
	in.read((char *) &aamp, sizeof(float));
	in.read((char *) &adur, sizeof(float));
	in.read((char *) &minfreq, sizeof(float));
	in.read((char *) &maxfreq, sizeof(float));
	in.read((char *) &scaleamp, sizeof(float));
	in.read((char *) &scaledur, sizeof(float));
	in.read((char *) &activeCPs, sizeof(int));
	in.read((char *) &lehmera, sizeof(float));
	in.read((char *) &lehmerc, sizeof(float));
	
	in.read((char *) controlflags, sizeof(int)*NUMPARAMETERS);
	
	//update associated GendynSynthesis? 
	

}


//transfer constants over
void GendynPreset::CopyToGendynSynthesis(GendynSynthesis * synth) {
	
	synth->mAmplitude = amplitude; 
	
	synth->algorithm = algorithm; 
	
	synth->whichamp = whichamp;  
	synth->whichdur = whichdur;
	synth->aamp = aamp; 
	synth->adur = adur; 
	synth->minfreq = minfreq;
	synth->maxfreq = maxfreq;
	synth->scaleamp = scaleamp;
	synth->scaledur = scaledur;
	synth->activeCPs = activeCPs; 
	synth->lehmera = lehmera;
	synth->lehmerc = lehmerc;
	

}


void GendynPreset::Default1() {
	
	algorithm=0; //basic 0, hoffmann 1, can't be modulated live
	amplitude = 1.0; 
	
	whichamp= 1;
	whichdur= 1;
	aamp = 1.0;
	adur = 1.0;
	minfreq = 44; //440
	maxfreq = 220; //660
	scaleamp = 0.5;
	scaledur = 0.5; 
	activeCPs = 9; 
	
	lehmera=1.17; 
	lehmerc=0.31;
	
	for (int i=0; i<NUMPARAMETERS; ++i)
		controlflags[i]= 5; //nothing mapped through? 
		
	controlflags[0] = 0; //amplitude on x
	controlflags[5] = 1; //minfreq on y
	controlflags[6] = 3; //maxfreq on ay
	controlflags[7] = 2; //scaleamp on ax
	controlflags[8] = 2; //scaledur on ax
	

}

void GendynPreset::Default2() {
	Default1(); 
	
	algorithm= 1; 
	
	controlflags[10] = 3; //lehmera on ay
	controlflags[11] = 4; //lehmerc on az
	
}

//no good
void GendynPreset::Default3() {
 
	algorithm=1; //basic 0, hoffmann 1, can't be modulated live
	amplitude = 1.0; 
	
	whichamp= 1;
	whichdur= 1;
	aamp = 1.0;
	adur = 0.9;
	minfreq = 800.0; //440
	maxfreq = 1000.0; //660
	scaleamp = 0.1;
	scaledur = 0.5; 
	activeCPs = 8; 
	
	lehmera=1.17; 
	lehmerc=0.31;
	
	for (int i=0; i<NUMPARAMETERS; ++i)
		controlflags[i]= 5; //nothing mapped through? 
	
	controlflags[0] = 1; //amplitude on y

	//controlflags[9] = 2; //CPs on ax 
	
	controlflags[1] = 0; 
	controlflags[2] = 0;
	
	controlflags[3] = 4; 
	controlflags[4] = 2;
	
	//controlflags[5] = 0; //minfreq on x
	//controlflags[6] = 1; //maxfreq on y
	
	controlflags[10] = 1; //lehmera on az
	controlflags[11] = 4; //lehmerc on az
	controlflags[8] = 3; //scaledur on ay
	
}

//transfer data to synthesis class
void GendynPreset::UpdateGendynSynthesis(GendynSynthesis * synth, int which, float input) {

	//if constant, pass data over, else assuming passed on the fly from controllers? 
	for (int i=0; i<NUMPARAMETERS; ++i) {
		if(controlflags[i]==which) {
			
			switch(i) {
				case 0: {
					amplitude = input*input; //(int)input*5.999999; 
					synth->mAmplitude = amplitude; 
				}
					break;
				case 1: {
					whichamp = (int)(input*5.999999);
					synth->whichamp = whichamp; 
				}
					break;
				case 2: {
					whichdur = (int)(input*5.999999); 
					synth->whichdur = whichdur; 
				}
					break;
				case 3: {
					aamp = input; //(int)input*5.999999;
					synth->aamp = aamp; 
				}
					break;
				case 4: {
					adur = input; //(int)input*5.999999;
					synth->adur = adur; 
				}
					break;
				case 5: {
					
					//float oldmaxfreq = maxfreq- minfreq; 
					
					minfreq = input*1000.0; //(input*600.0)+20.0; 
					//just let it be and see what occurs...
					//if(minfreq>maxfreq) maxfreq= minfreq;
					
					//maxfreq = minfreq + oldmaxfreq; 
				
					synth->minfreq = minfreq; 
					//synth->maxfreq = maxfreq;
					}
					break;
				case 6: {
					//maxfreq = 3000.0*input; 
					//maxfreq = minfreq + (2000.0*input); //(input*600.0)+20.0; 
					maxfreq = minfreq + (2500.0*input); 
					//if(maxfreq<minfreq) minfreq= maxfreq;
					synth->maxfreq = maxfreq;
				}
					break;
				case 7: {
					scaleamp = input;
					synth->scaleamp = scaleamp;
				}
					break;
				case 8: {
					scaledur = input;  
					synth->scaledur = scaledur;
				}
					break;
				case 9: {
					activeCPs = ((int)(input*8.999999)) + 1;
					synth->activeCPs = activeCPs; 
				}
					break;
				case 10: {
					lehmera = input; //as per original *2.0; 
					synth->lehmera = lehmera;
				}
					break;
				case 11: {
					lehmerc = input; //as per original *4.0; 
					synth->lehmerc = lehmerc;
				}
					break;
					
					//				case 0: 
					//					whichamp = (int)input*5.999999; 
					//					break;
					
				default:
					break;
			}
			
		}
		
	}
	

}

//normalized input 0.0 to 1.0, for control which
//void UpdateFromControl(int which, float input) {
//	 
//	for (int i=0; i<NUMPARAMETERS; ++i)
//		if(controlflags[i]==which) {
//		
//			switch(i) {
//				case 0: 
//					whichamp = (int)input*5.999999; 
//					break;
//
//				default:
//					break;
//			}
//			
//		}//mapped through? 
//	
//	
//}
//
//
//void UpdateParameter(int whichparam, float input) {
//	
//	
//	
//	
//}















