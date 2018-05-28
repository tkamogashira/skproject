function Y = QPlayPrep(Srate, Dev, doForce);
% QplayPrepNew - prepare sequenced D/A conversion by the RP2
%   QplayPrep(Srate, Dev) prepares a sequenced play over device Dev.
%   Srate is the sample rate in kHz (see RP2 manual); default sample
%   rate is 100 kHz. Dev defaults to 'RP2_1'.
%
%   QplayPrep loads the RP2 circuit and runs it in its
%   "silent state". To avoid any audible artifacts, set the
%   attenuators to a high value SeqPlayPrepare.
%
%   In addition, the DACDelay of the RP2 is measured and returned as 
%   a struct containing mean and standard deviation in us. The  DACDelay is the 
%   delay between sending a sample to the DAC and its appearance at the DAC output.
%   The following connections have to be made for measuring the DACDelay:
%       RP2: analog  OUT-1  ->  IN-13  :RV8
%            digital OUT-2  ->  IN-7
%   Important note: a buffer must be placed between the OUT-1 ans IN-13 to
%   prevent distortion of the stimuli.
%
%   QplayPrep has to be used *before* any other SeqPlayxxx function.
%   rp_Sequencedplay.rco should reside in ../rpvds
%
%   QplayPrep('current') returns the current seqplay parameters but takes no action.
%   If SeqPlayPrep has not been called before in the session, SeqPlayPrep('current')
%   returns [].
%
%   Normal usage eg:QplayPrep(100)
%                   QplayLoad(w,l)
%                   QplayOrder([1 2 3 4 5 6])
%                   QplayGo
%
%   NOTE the RP2 plays 1 pulse on Out1 when circuit is loaded; the
%   attenuators are set to 120 dB.
%
%   See also QplayLoad, QplayOrder, QplayGo, QplayStop.

persistent QplayParams

if nargin<3, doForce=0; end
if nargin<2, Dev='RP2_1'; end
if nargin<1, Srate = 100; 
elseif isequal('current', lower(Srate)), % get or set on QplayParams
   if nargin<2, % query only; no action
   else, % add/edit field 
      FieldName = inputname(2);
      FieldValue = Dev;
      QplayParams = setfield(QplayParams, FieldName, FieldValue);
   end
   Y = QplayParams;
   return;
end;

% if the seqplay circuit is running on the RP2 with the right sample rate, no action is needed; ...
% ... in that case, just return the mean delay and its standard deviation.
if ~isempty(QplayParams) & ~doForce,
   if isequal(Srate, QplayParams.Srate) & isequal(Dev, QplayParams.Dev), % same sample rate and device - OK
      % make sure circuit is not converting
      sys3setpar(0, 'DoConvert', Dev);
      sys3run(Dev); 
      Y = QplayParams;
      return;
   end
end

% load circuit on RP2
Fsam = sys3loadCOF('rp_Qplay', Dev, Srate);             
% make sure circuit is not converting
sys3setpar(0, 'DoConvert', Dev);
% zero out both sample buffers
sys3zero('samples1', Dev);
sys3zero('samples2', Dev);
sys3run(Dev); 

QPLAYPREP_DEBUG = 1
chunkLen1 = []; chunkLen2 = []; 
offset1 = []; offset2 = []; % initialize offsets of D/A chunks
QplayParams = collectInstruct(Dev, Srate, Fsam, chunkLen1, chunkLen2, offset1, offset2); Y = QplayParams; return % DEBUG

% -----------now measure the DACdelay-------------
% create pulse
syncPulse = [10e3*ones(1,20) zeros(1,20)];
QplayLoad(syncPulse);
Npulse = 10;
QplayOrder(ones(1,Npulse));
%capture delays and calculate mean and standard deviation of delays  
Delays = local_DelayChk(Srate, 'RV8_1', Npulse); 
SigmaDelay = std(Delays); 
MeanDelay = mean(Delays);  
NcycDelay = MeanDelay*Srate*1e-3;
if abs(NcycDelay/30-1)>0.15,
   warning('Mean DAC delay deviates from 30 sample periods by more than 15%.')
end
if SigmaDelay>1,
   error('Standard deviation of DAC delay measurement > 1 us.');
end
% store Srate and timing outcome in persistentt variable to save time upon next identical call
QplayParams = collectInstruct(Dev, Srate, Fsam, MeanDelay, SigmaDelay);
Y = SeqPlayParams;

%---------------locals-------------------------------
function [Delays] = local_DelayChk(Srate, RV8, Nevents);  
%  DELAYCHK - get delays between pulses on In7 and In13 on the RV8_1   
sys3setpa5(120); % make sure sound is not transferred to headphones
% load RV8 circuit, set parameters and run
sys3loadCOF('rv_timestamp', RV8, 50); 
sys3setpar(7, 'BitIn1', RV8); % timestamp1 reads from Din 7 = RP2(Diout_2)
sys3setpar(13, 'BitIn2', RV8); % timestamp2 reads from Din 13 = RP2(AnalogOut)
sys3run(RV8);  
sys3trig(1, RV8); %start Tslope and get ready to capture stamps 
% let the RP2 play the digital and analog pulses
QplayGo; 
tic;          
% wait until all "digital events" (Di7) have been timestamped on RV8, then process the timestamps
NdiEvents = 0; 
while NdiEvents < Nevents, 
    NdiEvents = sys3getpar('StmpIdx1', RV8);  
    if toc>10, % don't wait for ever in case of cabling problems etc
       error('Insuficient number of TTL pulses detected over Di7 of RV8. Check wiring.');
    end; 
end  
sys3trig(2, RV8); % stop capturing 
sys3halt(RV8);  %stop running RV8
% get timestamp & Tslope values. Convert all values to us.
diTslope  = 1000*sys3read('Tslope1', RV8, 1+Nevents, 0, 'F32');  % time slope values in7
diStmps  = 1000000*sys3read('Stmp1', RV8, 1+Nevents, 0, 'F32');  % timestamps from first serbuffer on RV8_1, in7  
anTslope  = 1000*sys3read('Tslope2', RV8, Nevents, 0, 'F32');  % time slope values in13
anStmps  = 1000000*sys3read('Stmp2', RV8, Nevents, 0, 'F32');  % timestamps from second serbuffer on RV8_1, in13
% combine Tslope & timestamps to arrival times. 
diEvents = diStmps(2:Nevents+1) + diTslope(2:Nevents+1); % Ignore 1st pulse; it was sent out for playing 2nd buffer of 5 zeros  
anEvents = anStmps(1:Nevents) + anTslope(1:Nevents);                                                                          
Delays = anEvents - diEvents;
    

  



