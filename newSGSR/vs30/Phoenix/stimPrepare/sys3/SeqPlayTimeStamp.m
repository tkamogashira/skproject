function SeqPlayTimeStamp(chan, Nevents);

%%this function shows how to implement the timestamping on the RV8.
%%chan specifies the channel to stamp, events are the times where an event occured,
%%thus the times where a waveform was played out since RP2 generates a pulse every time 
%%a waveform is sent out. Nevents specifies how many events to capture. (within 10 seconds)

Dev2 = 'RV8_1';

sys3loadCOF('rv_timestamp', Dev2, 50); 
sys3setpar(7, 'BitIn1', Dev2);                                          %%set channel to timestamp
sys3run(Dev2);                                                          %%run the RV8_1 circuit  
sys3trig(1, Dev2);                                                      %%start Tslope and get ready to capture stamps 

seqplaygo;                                      %%START PLAYING STIMULI

tic;  
nEvents = sys3getpar('StmpIdx1', Dev2);                                 %%wait for Nevents captured on in13
while nEvents < Nevents,                             
    nEvents = sys3getpar('StmpIdx1', Dev2);  
    if toc>20, disp('timeout'); break; end;                             %% TIMEOUT  
end  
  
sys3trig(2, Dev2);                                                      %%stop capturing   
  
Stmps  = 1000000*sys3read('Stmp1', Dev2, Nevents, 0, 'F32');            %%read in timestamps (sec)from first serbuffer on RV8_1, in7  
Tslope  = 1000*sys3read('Tslope1', Dev2, Nevents, 0, 'F32');  
  
sys3halt(Dev2);                                                         %%stop running RV8



Events(1:Nevents) = Stmps(1:Nevents) + Tslope(1:Nevents);               %%calculate time in uSec
global events;
events = Events

