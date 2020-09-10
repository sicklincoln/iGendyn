/*
 *  GendynSynthesis.cpp
 *
 *  Created by Nicholas Collins on 27/04/2009.
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "GendynSynthesis.h"

//not available
//RGen& rgen = *mParent->mRGen;
//use Objective C random function? 
//use arc4random() for cryptographic strength, is long range
//(float)rand()/RAND_MAX
//(float)random()/RAND_MAX
//RAND_MAX 0x7fffffff
//reciprocal 4.6566128752458e-10
#define frand() 4.6566128752458e-10*(float)rand()



//=44100.0
GendynSynthesis::GendynSynthesis(float sampleRate)  //:(int)anX andY:(int)anY 
{ 
	mAmplitude = 0.5; //
	mFreqMul = 1.0/sampleRate; //mRate->mSampleDur;
	mPhase = 1.f;	//should immediately decide on new target 
	mAmp = 0.0; 
	mNextAmp = 0.0;
	mSpeed = 100; 
	
	mDur= 1.0; //needs initialisation else error? 
	
	//avoid pushing too hard on computer
	mMemorySize= 9; //12; //(int) ZIN0(8);	//default is 12
	activeCPs= mMemorySize; 
	//printf("memsize %d %f", mMemorySize, ZIN0(8));
	if(mMemorySize<1) mMemorySize=1;
	
	mIndex=0;
	mMemoryAmp= (float *)malloc(mMemorySize*sizeof(float)); //(float*)RTAlloc(mWorld, mMemorySize * sizeof(float));
	mMemoryDur= (float *)malloc(mMemorySize*sizeof(float)); //(float*)RTAlloc(mWorld, mMemorySize * sizeof(float));
	
	//accommmodate alternative algorithm= second order walk, a la Hoffmann
	mMemoryAmpStep= (float *)malloc(mMemorySize*sizeof(float)); //(float*)RTAlloc(mWorld, mMemorySize * sizeof(float));
	mMemoryDurStep= (float *)malloc(mMemorySize*sizeof(float)); //(float*)RTAlloc(mWorld, mMemorySize * sizeof(float));

	//if want zeroed, use calloc(mMemorySize,sizeof(float));
	//should check if mMemoryApp is NULL, but will assume no problems
	
	//initialise to zeroes and separations
	int i=0;
	for(i=0; i<mMemorySize;++i) {
		mMemoryAmp[i]=2*frand() - 1.0;
		mMemoryDur[i]=frand();
		mMemoryAmpStep[i]=2*frand() - 1.0;
		mMemoryDurStep[i]=2*frand() - 1.0;
	}

	
	//ampdist=1, durdist=1, adparam=1.0, ddparam=1.0, minfreq=440, maxfreq=660, ampscale= 0.5, durscale=0.5, initCPs= 12, knum,
	whichamp= 1;
	whichdur= 1;
	aamp = 1.0;
	adur = 1.0;
	minfreq = 44; //440
	maxfreq = 200; //660
	scaleamp = 0.5;
	scaledur = 0.5; 
	
	lehmera=1.17; 
	lehmerc=0.31;
	
	algorithm=0; //basic 0, hoffmann 1
	
	running=0; 
	juststarted=0; 
	justended=0; 
	
	fadefunction= (float *)malloc(FADEBUFFERSIZE*sizeof(float)); //(float*)RTAlloc(mWorld, mMemorySize * sizeof(float));

	//fade in at beginning
	for(i=0; i<FADESIZE;++i) {
		float temp= (float)i/FADESIZE; 
		temp*=temp; //squared
		fadefunction[i]= temp; 
		fadefunction[FADEBUFFERSIZE-i-1]=temp; 
	}
	
	for(i=FADESIZE; i<ENDFADE;++i) {
		fadefunction[i]= 1.0;
	}
		
	fadein = fadefunction; 
	nofade= fadefunction+FADESIZE; 
	//can't precalculate fadeout position because of differences in potential buffer size 
	
} 


GendynSynthesis::~GendynSynthesis()
{ 
	free(mMemoryAmp);
	free(mMemoryDur);
	free(mMemoryAmpStep);
	free(mMemoryDurStep);
	free(fadefunction);
} 

//dealloc
//RTFree(mWorld, mMemoryAmp);
//RTFree(mWorld, mMemoryDur);


//variables of class should be set from GUI elsewhere? 

//int g_num=6; //12; 

//lots of correction to do here
void GendynSynthesis::calculate(int inNumSamples, float * output) 
{
	
	if (running | justended) {
		
		int counter; 
		
		//float *out = ZOUT(0);
		
		//distribution choices for amp and dur and constants of distribution
		
		//printf("called Gendyn %d %f \n", inNumSamples, frand());
		
		//main controls to attach to accelerometer and touch controls 
		//	int whichamp= (int)ZIN0(0);
		//	int whichdur= (int)ZIN0(1);
		//	float aamp = ZIN0(2);
		//	float adur = ZIN0(3);
		//	float minfreq = ZIN0(4);
		//	float maxfreq = ZIN0(5);
		//	float scaleamp = ZIN0(6);
		//	float scaledur = ZIN0(7); 
		//	
		//	
		
		//int whichamp= (int)ZIN0(0);
		//int whichdur= (int)ZIN0(1);
		
		float rate= mDur;
		
		//phase gives proportion for linear interpolation automatically
		double phase = mPhase;
		
		float amp= mAmp;
		float nextamp= mNextAmp;
		
		float speed= mSpeed;
		
		//RGen& rgen = *mParent->mRGen;
		//linear distribution 0.0 to 1.0 using rgen.frand()
		
		float ampdiff= nextamp- amp; 
		
		//if transition state on or off, add 0 to 1 
		float * fadebuf= nofade; 
		
		if(juststarted) fadebuf= fadein;
		if(justended) {
			fadebuf= fadefunction+FADEBUFFERSIZE-inNumSamples;
		}
		
	for(counter=0;counter<inNumSamples;++counter) { 
		float z;
		
		if (phase >= 1.f) {
			phase -= 1.f;
			
			int index= mIndex;
			
		//	if(frand()<0.01) {
//				whichamp= 0.5+(frand()*6.0); 
//				whichdur= 0.5+(frand()*6.0); 
//			}
			
			
			//g_num= 0.5+(frand()*6.0);
			
			int num= activeCPs; //g_num;  //HARD CODED for now (int)(ZIN0(9));//(mMemorySize);(((int)ZIN0(9))%(mMemorySize))+1;
			if((num>(mMemorySize)) || (num<1)) num=mMemorySize;
				
				//new code for indexing
				index=(index+1)%num;
			
				float lehmerxen= fmod(((amp)*lehmera)+lehmerc,1.0f);  //only needed for algorithm 1 but safest to just do it here
			
				amp=nextamp;
				
				mIndex=index;
				
			
			//either update via Gendy 1 (algorithm 0 ) or second order update(Gendy2)
			if(algorithm==0) {
				
				//
				//Gendy dist gives value [-1,1], then use scaleamp
				//first term was amp before, now must check new memory slot
				//Gendyn_distribution(whichamp, aamp,frand())
				nextamp= (mMemoryAmp[index])+(scaleamp*Gendyn_distribution(whichamp,aamp,frand()));
			//	
//				//mirroring for bounds- safe version 
//				if(nextamp>1.0 || nextamp<-1.0) {
//					
//					//printf("mirroring nextamp %f ", nextamp);
//					
//					//to force mirroring to be sensible
//					if(nextamp<0.0) nextamp=nextamp+4.0;
//					
//					nextamp=fmod(nextamp,4.0f); 
//					//printf("fmod  %f ", nextamp);
//					
//					if(nextamp>1.0 && nextamp<3.0)
//						nextamp= 2.0-nextamp;
//					
//					else if(nextamp>1.0)
//						nextamp=nextamp-4.0;
//					
//					//printf("mirrorednextamp %f \n", nextamp);
//				};
//				
//				mMemoryAmp[index]= nextamp;
				
				//Gendy dist gives value [-1,1]
				//Gendyn_distribution(whichdur, adur, frand())
				rate= (mMemoryDur[index])+(scaledur*Gendyn_distribution(whichdur,adur,frand()));
				
	//			if(rate>1.0 || rate<0.0)
//				{
//					if(rate<0.0) rate=rate+2.0;
//					rate= fmod(rate,2.0f);
//					rate= 2.0-rate;
//				}
//				
//				mMemoryDur[index]= rate;
				
				
			} else {
				
			    //Gendy dist gives value [-1,1], then use scaleamp
				//first term was amp before, now must check new memory slot
				
				float ampstep= (mMemoryAmpStep[index])+ Gendyn_distribution(whichamp, aamp, fabs(lehmerxen));
				ampstep= Gendyn_mirroring2(-1.0,1.0,ampstep);
				
				mMemoryAmpStep[index]= ampstep;
				
				nextamp= (mMemoryAmp[index])+(scaleamp*ampstep);
				
	//			nextamp= Gendyn_mirroring2(-1.0,1.0,nextamp);
//				
//				mMemoryAmp[index]= nextamp;
//				
				float durstep= (mMemoryDurStep[index])+ Gendyn_distribution(whichdur, adur,frand());
				durstep= Gendyn_mirroring2(-1.0,1.0,durstep);
				
				mMemoryDurStep[index]= durstep;
				
				rate= (mMemoryDur[index])+(scaledur*durstep);
				
		//		rate= Gendyn_mirroring2(0.0,1.0,rate);
//				
//				mMemoryDur[index]= rate;
//				
				
			}
			
			nextamp= Gendyn_mirroring2(-1.0,1.0,nextamp);
			
			mMemoryAmp[index]= nextamp;
			
			rate= Gendyn_mirroring2(0.0,1.0,rate);
			
			mMemoryDur[index]= rate;
			
			//printf("nextamp %f rate %f \n", nextamp, rate);
			
			//define range of speeds (say between 20 and 1000 Hz)
			//can have bounds as fourth and fifth inputs
			speed=  (minfreq+((maxfreq-minfreq)*rate))*(mFreqMul);
			//maxfreq is now freqrange
			//speed=  (minfreq+((maxfreq)*rate))*(mFreqMul);
			
			//if there are 12 control points in memory, that is 12 per cycle
			//the speed is multiplied by 12
			//(I don't store this because updating rates must remain in range [0,1]
			speed *= num;
			
			ampdiff= nextamp- amp; 
		} 
		
		//linear interpolation could be changed
		z = amp + (phase*ampdiff); //(phase*(nextamp-amp)); //((1.0-phase)*amp) + (phase*nextamp); // ((1.0-phase)*amp) + (phase*nextamp);
		
		phase +=  speed;
		
		//printf("in audio callback and happy counter %d %f", counter, z);	
		output[counter] +=  z * mAmplitude * fadebuf[counter];
		
	//	if(justended && (counter>1020)) {
//			float temp1debug = fadebuf[counter];
//			float temp2debug = z * mAmplitude * fadebuf[counter];
//			output[counter]= temp2debug; //HACK!!!!!!!!! 
//		}
		
	} 
		
		
		
		if(justended) justended=0; 
		if(juststarted) juststarted=0; 
		
		
		mPhase = phase;
		mAmp =  amp;      
		mNextAmp = nextamp;
		mSpeed = speed;
		mDur = rate;	
		
		
	} else {
	
		//do nothing since summing nothing into buffer
	//for(counter=0;counter<inNumSamples;++counter) 
//		output[counter]=0.0; 
	}
	
	
}





float GendynSynthesis::Gendyn_mirroring (float lower, float upper, float in)
{
	//mirroring for bounds- safe version 
	if(in>upper || in<lower) {
		
		float range= (upper-lower);
		
		if(in<lower) in= (2*upper-lower)-in;
		
		in=fmod(in-upper,2*range);
		
		if(in<range) in=upper-in;
		else in=in- (range);
	}
	
	return in;
}

float GendynSynthesis::Gendyn_mirroring2 (float lower, float upper, float in)
{
	//mirroring for bounds- safe version
	if(in>upper || in<lower) {
		float range= (upper-lower);
        float rangetwice = 2.f*range;
        float x = in-lower;
        
		if(x<0.f)
			x = -x;
        
		x = fmod(x,rangetwice);
        
		if(x<range)
			in = lower + x;
		else
			in = (rangetwice-x)+lower;
	}
    
	return in;
}




float GendynSynthesis::Gendyn_distribution(int which, float a, float f)
{
	
	float temp, c;
	
	if(a>1.0) a=1.0;       //a must be in range 0 to 1
		if(a<0.0001) a=0.0001; 	//for safety with some distributions, don't want divide by zero errors
			
			switch (which)
		{
			case 0: //LINEAR
				//linear
				break;
			case 1: //CAUCHY
				//X has a*tan((z-0.5)*pi)
				//I went back to first principles of the Cauchy distribution and re-integrated with a 
				//normalisation constant 
				
				//choice of 10 here is such that f=0.95 gives about 0.35 for temp, could go with 2 to make it finer
				c= atan(10*a);		//PERHAPS CHANGE TO a=1/a;
				//incorrect- missed out divisor of pi in norm temp= a*tan(c*(2*pi*f - 1));	
				temp= (1/a)*tan(c*(2*f - 1));	//Cauchy distribution, C is precalculated
				
				//printf("cauchy f %f c %f temp %f out %f \n",f,  c, temp, temp/10);
				
				return temp*0.1; //(temp+100)/200;
				
			case 2: //LOGIST (ic)
				//X has -(log((1-z)/z)+b)/a which is not very usable as is
				
				c=0.5+(0.499*a); //calculate normalisation constant
				c= log((1-c)/c); 
				
				//remap into range of valid inputs to avoid infinities in the log
				
				//f= ((f-0.5)*0.499*a)+0.5;
				f= ((f-0.5)*0.998*a)+0.5; //[0,1]->[0.001,0.999]; squashed around midpoint 0.5 by a
				//Xenakis calls this the LOGIST map, it's from the range [0,1] to [inf,0] where 0.5->1
				//than take natural log. to avoid infinities in practise I take [0,1] -> [0.001,0.999]->[6.9,-6.9]
				//an interesting property is that 0.5-e is the reciprocal of 0.5+e under (1-f)/f 
				//and hence the logs are the negative of each other
				temp= log((1-f)/f)/c;	//n range [-1,1]
				//X also had two constants in his- I don't bother
				
				//printf("logist f %f temp %f\n", f, temp);
				
				return temp; //a*0.5*(temp+1.0);	//to [0,1]
				
			case 3: //HYPERBCOS
				//X original a*log(tan(z*pi/2)) which is [0,1]->[0,pi/2]->[0,inf]->[-inf,inf]
				//unmanageable in this pure form
				c=tan(1.5692255*a);    //tan(0.999*a*pi*0.5);    	//[0, 636.6] maximum range
				temp= tan(1.5692255*a*f)/c;	//[0,1]->[0,1] 
				temp= log(temp*0.999+0.001)*(-0.1447648);  // multiplier same as /(-6.9077553); //[0,1]->[0,1]
				
				//printf("hyperbcos f %f c %f temp %f\n", f, c, temp);
				
				return 2*temp-1.0;
				
			case 4: //ARCSINE
				//X original a/2*(1-sin((0.5-z)*pi)) aha almost a better behaved one though [0,1]->[2,0]->[a,0] 
				c= sin(1.5707963*a); //sin(pi*0.5*a);	//a as scaling factor of domain of sine input to use
				temp= sin(3.1415926535898*(f-0.5)*a)/c; //[-1,1] which is what I need
				//was pi
				//printf("arcsine f %f c %f temp %f\n", f, c, temp);
				
				return temp;
				
			case 5: //EXPON
				//X original -(log(1-z))/a [0,1]-> [1,0]-> [0,-inf]->[0,inf]
				c= log(1.0-(0.999*a));
				temp= log(1.0-(f*0.999*a))/c;
				
				//printf("expon f %f c %f temp %f\n", f, c, temp);
				
				return 2*temp-1.0;
				
			case 6: //SINUS
				//X original a*sin(smp * 2*pi/44100 * b) ie depends on a second oscillator's value- 
				//hmmm, plug this in as a I guess, will automatically accept control rate inputs then!
				return 2*a-1.0;
				
			default:
				break;
		}
	
	return 2*f-1.0;
	
}



