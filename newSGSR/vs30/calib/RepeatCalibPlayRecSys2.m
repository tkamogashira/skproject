function [recSig, ANOM] = CalibPlayRecSys2(keyword, varargin);
% RepeatCalibPlayRecSys2 - basic play/record function for calibration using system II (PD1)
%5   syntax:
%     RepeatCalibPlayRecSys2('prepare', playSig, DACchannel, fltIndex, Atten, I)
%     [recSig, ANOM]=RepeatCalibPlayRecSys2('playrec', I);
%     RepeatCalibPlayRecSys2('cleanup');
%
% playSig, DACchannel, fltIndex, Atten);

global SGSR PD1
persistent DBNrecord DBNplay

% 16-bit dama buffers for play & record
% quite a number of samples seem to get lost in a combined 
% play/record action, even when the DAC output of the PD1 is 
% directly connected to the ADC. For the present routing,
% the delay for this setup is 9 samples, independent of
% sample frequency. The first sample of the play seems to 
% be played, so we only need trailing zeros, not heading zeros.
N_LAG = 9;

switch lower(keyword),
case 'debug', keyboard;
case 'prepare',
   % store samples, allocate buffers, set hardware
   [playSig, DACchannel, fltIndex, Atten, ibuffer] = deal(varargin{1:5});
   % store playsig in dama
   Nplay = length(playSig) + N_LAG;
   DBNplay(ibuffer) = ML2dama([playSig(:)' zeros(1, N_LAG)]);
   DBNrecord = ML2dama(zeros(1, Nplay));
   % routing etc
   localPrepareHardware(Nplay, fltIndex, DACchannel, Atten);
case 'playrec',
   ibuffer = varargin{1}; % which buffer to play
   % trigger PD1
   % AP2 play & record instructions
   s232('record',DBNrecord);
   s232('play',DBNplay(ibuffer));
   s232('PD1arm',1);
   s232('PD1go',1);
   % wait until conversion has finished and get recorded samples
   while (s232('PD1status',1)~=0), end;
   pause(0.1);
   s232('PD1clrIO',1);
   recSig = dama2ML(DBNrecord); % dama -> Matlab
   % throw away first N_LAG garbage samples (see comment above)
   recSig(1:N_LAG) = [];
   % HARDWARE PROBLEMS -- quick & dirty fix
   ANOM = 0;
   [recSig, ANOM] = localFIXspikes(recSig);
case 'cleanup',
   % deallocate dama buffers
   for ibuffer=1:length(DBNplay), s232('deallot', DBNplay(ibuffer));  end;
   DBNplay = [];
   s232('deallot', DBNrecord); 
end % switch/case


%----------------locals---------
function [X, ANOM] = localFIXspikes(X);
ANOM = 0;
jumps = find(abs(X)>6*std(X));
if isempty(jumps), return; end;
ANOM = 1;
for isam=jumps,
   if isam==1, X(isam)=0;
   else, X(isam)= X(isam-1);
   end
end
% DD(jumps) = 0;
% X = cumsum(DD);

function localPrepareHardware(Nplay, fltIndex, DACchannel, Atten);
global SGSR PD1
ADCchannel = SGSR.ADCchannel;
SamP = 1e6/SGSR.samFreqs(fltIndex);
% routing is not standard because of combined play/record action
nStreams = [1 1]; % 1-IB, 1 OB
specOB = [1, PD1.OB(1), PD1.ADC(ADCchannel)]; % OB[0] <- ADC[x]
DACchannel = ChannelNum(DACchannel);
switch DACchannel
case {1,2}, % single-channel D/A
   specIB = [1, PD1.IB(1), PD1.DAC(DACchannel)]; % IB[0] -> DAC[0]
   addSimp = [];
otherwise, % dual channel D/A
   addSimp = [1, PD1.ireg(1), PD1.DAC(1) ; ... % ireg[0] -> DAC[0]
         1, PD1.ireg(1), PD1.DAC(2)]; % ireg[0] -> DAC[1]
   specIB =  [1, PD1.IB(1), PD1.ireg(1)]; % IB[0] -> ireg[0]
end
% SS1 switching  is trivial - not dependent on A/D
[preGo, postGo] = SS1switching(DACchannel, fltIndex); % preGo is final connection
preGo = [preGo; postGo]; % at once in final setting
HWsettings = CollectInStruct(Nplay, SamP, nStreams, addSimp, specIB, specOB, preGo);
prepareHardware4DA(HWsettings);
% attenuators
setPA4s(Atten);
pause(0.1);

