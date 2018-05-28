function [Mean, Std] = sys3DacDelay(Nevents, reqPulsePer, reqSrate);  
  
%  SYS3DACDELAY - get mean DACdelay on the RX6 and its standard deviation  
%  
%     Sys3DacDelay.m should be in                            somedir/mfiles  
%     rp_pulsegen.rco and rv_delaychk.rco files should be in somedir/rpvds  
%  
%     SYS3DACDELAY(Nevents, reqPulsePer, reqSrate, Dev) returns the mean and std of Nevents delays between Nevents pulses of a pulsetrain,  
%                                               with a reqPulsePer uSec period. Period is rounded to closest possible value.      
%                                               reqSrate sample rate is 25, 50 or 100 kHz  
%
%     SYS3DACDELAY takes Nevents = 1000, reqPulsePer = 1000uSec and reqSrate = 50kHz as defaults  
%  
%     See also DELAYCHK  
  
if nargin <1,   
    Nevents = 1000;  
    reqPulsePer = 1000;  
    reqSrate = 50;  
end  

Dev1 = 'RP2';
Dev2 = 'RX6';
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% calculate pulse period                  %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
Srate = sys3loadCOF('rp_pulsegen', Dev1, reqSrate);               %%get real sampling rate  
Sper = 1/Srate;                                                    %uSec   
Nper = round(reqPulsePer/(Sper*1000000))                          %calculate real value for Nper based on requested pulse period  
PulsePer = Nper * Sper * 1000000;                                  %actual pulse period in uSec   
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% measurements                            %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
done = 0;  
  
while ~done,  
    [Delays, OK] = local_DelayChk(Nevents, Nper, PulsePer, reqSrate, Dev1, Dev2);  %%capture delays  
    if ~OK                                                             %%happens when not all events captured => erroneous meaurement      
        disp('wrong data, skippin check')                              %%so we don't include them  
        done = 0;  
    else  
        done = 1;  
    end     
end  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% calculate results                       %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
Std = std(Delays);                                              %%calculate mean ans standard deviation of delays  
Mean = mean(Delays);  
%hist(Delays)  
  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% local function                          %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
function [Delays, OK] = local_DelayChk(Nevents, Nper, PulsePer, reqSrate, Dev1, Dev2);  
  
%  DELAYCHK - get delays between pulses on In7 and In13 on the RV8_1   
%  
%     Calibrate.m and DelayChk.m files should be in          somedir/mfiles  (DELAYCHK is called by CALIBRATE)  
%     rp_pulsegen.rco and rv_delaychk.rco files should be in somedir/rpvds  
%  
%     DELAYCHK(Nevents, Nper, PulsePer, reqPulsePer, reqSrate, Dev1, Dev2)   
%                                       returns Nevents delays between Nevents pulses of a pulsetrain,  
%                                       with a PulsePer uSec period on devices Dev1 and Dev2
%                                       reqSrate sample rate is 25, 50 or 100 kHz  
%  
%     DELAYCHK  takes Nevents = 1000, Nper = 100, PulsePer = 2048uSec and reqSrate = 50kHz by default  
%  
%     See also CALIBRATE, since this function is to be called by CALIBRATE  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% circuits are loaded, runned and stopped %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
sys3loadCOF('rp_pulsegen', Dev1, reqSrate);      %%load circuits          
sys3loadCOF('rv_timestamp', Dev2, 50);  

sys3setpar(7, 'BitIn1', Dev2);                   %%set Bit In channels 7 and 13
sys3setpar(13, 'BitIn2', Dev2);    
  
sys3setpar(Nper, 'NPer', Dev1);                  %%sets the pulse period eg Nper=2 => period = 2*20.48 uSec  
  
sys3run(Dev1);                                   %%run the RP2_1 circuit  
sys3run(Dev2);                                   %%run the RV8_1 circuit  
  
sys3trig(1, Dev2);                               %%start Tslope and get ready to capture stamps  
sys3trig(1, Dev1);                               %%start pulsetrains  
  
tic;                                              %% set stopwatch  
DiEvents = sys3getpar('StmpIdx1', Dev2);       %%# events captured on in13, where analog pulses reside  
while DiEvents < Nevents,                        %%# events captured on in7 will always be more  
    DiEvents = sys3getpar('StmpId1', Dev2);  
    if toc>10, disp('timeout'); break; end;                        %% TIMEOUT  
end  
  
sys3trig(2, Dev2);                               %%stop capturing   
sys3trig(2, Dev1);                               %%stop pulsetrains  
  
  
diStmps  = 1000000*sys3read('Stmp1', Dev2, Nevents, 0, 'F32');      %%read in timestamps (sec)from first serbuffer on RV8_1, in7  
anStmps  = 1000000*sys3read('Stmp2', Dev2, 2*Nevents, 0, 'F32');      %%read in timestamps from second serbuffer on RV8_1, in13  
anTslope  = 1000*sys3read('Tslope1', Dev2, 2*Nevents, 0, 'F32');      %%read in time slope values (mSec)  
diTslope  = 1000*sys3read('Tslope2', Dev2, Nevents, 0, 'F32');  
  
sys3halt(Dev2);      
sys3halt(Dev1);                                  %%stop devices  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% now calculate delays and results %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
diEvents = diStmps + diTslope;                        
anEvents = anStmps + anTslope;  
  
idecreasing = min(find(diff(anEvents)<0));  
  
disp(anEvents(idecreasing - 10: idecreasing + 10))  
disp(anStmps(idecreasing - 10: idecreasing + 10))  
  
if ~isempty(idecreasing),   
    anEvents = anEvents(1:(idecreasing));   
    disp('decreasing vals removed');   
end;                                                %% throw out non-increasing timestaps  
                        
  
iwrong = find(diff(anEvents)< 0.7 * PulsePer);   %%spurious fast "echos"  
anEvents(iwrong+1) = [];                         %%throw out the fast echo samples  
anEvents = anEvents(1:Nevents);  
  
OK = 1;  
  
if length(anEvents)~=Nevents,   
    Ndetected = length(anEvents)  
    Nevents  
    OK = 0;  
    Delays = [];  
else  
    Delays = anEvents - diEvents;   
end;  
  
  
  
  
  
  
  
