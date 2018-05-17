7/21/01 LHC	  ARLO model for EARLAB website

This is C code (prepared by Xuedong Zhang) for the AN model described in 
"Auditory nerve model for predicting performance limits 
of normal and impaired listeners," Heinz, M.G., Zhang, X., Bruce, I.C., 
and Carney, L.H. ARLO (2001) 2:91-96.

This code is written in C, such that it is compatible with MATLAB.

After loading all of these files into your directory,
In Matlab, type: compile_ARLO 
     to create a mex file (an_arlo) that can be called as a Matlab function.

Run test.m in matlab to test the model - this code provides a simple example.

The basic call to the model is as follows:

>> sout(:,index) = an_arlo([tdres,cf,spont,model,species,ifspike],sig');

where 'sout' is the synapse output (in sp/sec) as described in JASA 2001.

Note the following INPUT parameters are required to run the model:

tdres: is the time-domain resolution of the input stimulus waveform in seconds-
    this sets the temporal resolution is used throughout the model.
cf: is the characteristic frequency of a single AN fiber, in Hz.
spont: is spontaneous rate, in sp/sec
model: refers to the version of the model used, as follows:
	Model numbers as used in ARLO Heinz et al., Fig. 4 -
	1: Nonlinear_w/compression & suppression (model for 'healthy' ear)
	2: Nonlinear_w/compression, but without off-frequency suppression
        3: Linear sharp
        4: Linear broad, low threshold
        5: Linear broad, high threshold
      
species: refers to the species modeled -
    where 0 = human (as in ARLO paper)
          9 = cat, all CFs (as in JASA 2001 Zhang et al., paper)  
          1 = cat, only low CFs (as in Carney '93 JASA paper - not recommended)
ifspike: is a flag related to whether or not spikes are generated.
    if ifspike = 0, the sout is scaled (with parameter Ass) to yield appropriate 
	average rates _without_ refractoriness (as in ARLO)
    if ifspike = 1, the sout is scaled (with parameter Ass) to yield higher rates, 
	such that after spike generation with refractoriness, average rates 
	are again appropriate.
Finally, sig is an array that holds the stimulus waveform, scaled in pascals and
 	sampled at the resolution specified in the input parameter tdres.

To generate spike times, see latter part of the example program test.m:
the function call is:
>> [sptime,nspikes] = sgmodel([tdres, nrep],sout);
   where tdres is the same as above, and nrep is the number of repetitions.
(This function runs fine in Matlab6 version 12, had problems in Matlab5.3.)

Good Luck!  -Laurel Carney  7/30/01