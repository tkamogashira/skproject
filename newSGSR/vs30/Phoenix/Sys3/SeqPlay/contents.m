% SeqPlayXXX - Functions for sequence playback on Sys 3 devices
%   Rather than sending long buffers to a Sys 3 device, one can play sequences of 
%   shorter buffers. To do this, use the functions listed below. These call all 
%   needed Sys 3 functions.
%   
%   SeqPlayInit
%     First use SeqPlayInit to load the circuit to the correct device, and 
%     set the sampling frequency.
%   
%   SeqPlayUpload
%     Next, send the wavefroms you want to play to your Sys 3 device using 
%     SeqPlayUpload.
%   
%   SeqPlayList
%     Once the samples have been uploaded, use SeqPlayList to specify the 
%     order and amount of times you want to play your samples.
%   
%   SeqPlayGo
%     Once all is set up, use SeqPlayGo to start playing the specified 
%     sequence.
%   
%   SeqPlayStatus
%     To check the status and progress of sequence playback, use SeqPlayStatus.
%   
%   SeqPlayHalt
%     Use SeqPlayHalt to immediately terminate playback, even if your sequence 
%     has not been finished.
%
%   -----Test & Debug functions ----------
%
%   SeqplayInfo - current status of Seqplay circuit
%   SeqplayPlot - plot buffer contents of seq play (debug function)
%   sing - audio test using Seqplay functionality
%   SeqplayReview - plot "real" output of seqplay circuit: DEBUG circuit only