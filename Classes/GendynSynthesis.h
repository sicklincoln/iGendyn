//#if !defined(__GendynSynthesis_h__)
//#define __GendynSynthesis_h__
#pragma once

//#define FADESIZE 64
//#define FADEBUFFERSIZE 4160
//#define STARTFADE 0
//#define ENDFADE 4096


#define FADESIZE 256
#define FADEBUFFERSIZE 4512
#define STARTFADE 0
#define ENDFADE 4256

class GendynSynthesis 
{
public:
	double mPhase;
	float mFreqMul, mAmp, mNextAmp, mSpeed, mDur;      
	int mMemorySize, mIndex;
	float* mMemoryAmp; 	//could hard code as 12
	float* mMemoryDur;	
	float* mMemoryAmpStep;
	float* mMemoryDurStep;
	
	//for UI control? 
	
	float mAmplitude; //total amplitude multiplier
	
	//will be same distribution for the moment? 
	int whichamp;
	int whichdur;
	float aamp;
	float adur;
	float minfreq;
	float maxfreq;
	float scaleamp;
	float scaledur; 
	float activeCPs;
	float lehmera, lehmerc; 
	
	int algorithm; 
	int running; 
	int juststarted; 
	int justended; 
	float * fadefunction; 
	float * fadein; 
	//float * fadeout; 
	float * nofade; 
	
	GendynSynthesis(float sampleRate);
	~GendynSynthesis();
	void calculate(int inNumSamples, float * output);
	float Gendyn_distribution(int which, float a, float f);
	float Gendyn_mirroring (float lower, float upper, float in);
	float Gendyn_mirroring2 (float lower, float upper, float in);
	
};

//#endif
