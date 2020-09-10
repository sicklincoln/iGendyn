/*
 *  GendynPreset.h
 *  iGendyn
 *
 *  Created by Nicholas Collins on 24/05/2010.
 *  Copyright 2010 Nicholas M Collins. All rights reserved.
 *
 */

//#include <iostream>
#include <fstream>

#include "Constants.h"
#include "GendynSynthesis.h"

//using std::endl;
using std::ifstream; 
using std::ofstream;
using std::istream; 
using std::ostream;

class GendynPreset {

public:
	float amplitude; 
	int algorithm; 
	int whichamp;
	int whichdur;
	float aamp;
	float adur;
	float minfreq;
	float maxfreq;
	float scaleamp;
	float scaledur; 
	int activeCPs;
	float lehmera;
	float lehmerc; 
	
	int controlflags[NUMPARAMETERS]; //switch for what controls it
	
	
	
	GendynPreset();
	~GendynPreset(); 
	
	void Save(ostream&);
	void Load(istream&);
	
	//transfer data to synthesis class
	void UpdateGendynSynthesis(GendynSynthesis * synth, int which, float input);
	void CopyToGendynSynthesis(GendynSynthesis * synth); 
		
	void Randomize(); 
	void Default1(); 
	void Default2(); 
	void Default3(); 
	
	//normalized input 0.0 to 1.0, for control which
//	void UpdateFromControl(int which, float input);
//	
//	void UpdateParameter(int whichparam, float input);
//	
	//just do everything in above? 
	//internally called? 
	//void UpdateAlgorithm()
	
};