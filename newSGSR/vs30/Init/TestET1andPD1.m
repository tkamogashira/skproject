function [success, RR] = TestET1andPD1(Dev,NoFullCalib);

% tests ET1 and calibrates its clock re the PD1 whose
% internal clock is used by SGSR as a master clock.
% test is not performed if it has been performed recently
% (current setting is fixed and equal to 8 minutes).
% Note: this function needs the silence and synch buffers
% to be present - this is usually garantueed by 
% this function being called by cleanAP2 only (see cleanAP2)

persistent LastTimeTested
% initialize LastTimeTested
if isempty(LastTimeTested),
   LastTimeTested = clock*0;
end

% max time in s since last testing before new test is needed
if nargin<2,
   global SGSR
   MaxTestlessTime = SGSR.ET1calibrateInterval*60; % minutes->seconds
   TimeSinceLastTest = etime(clock,LastTimeTested);
   NoFullCalib = (TimeSinceLastTest<MaxTestlessTime);
end;

if nargin<1, Dev = 1; end;

success = 0;
try
   % 1. elementary test of ET1: clear, give a number of go's
   %   and check if they are properly processed.
   % 1. elementary test of ET1: clear, give a number of go's
   %   and check if they are properly processed.
   testType = 'go/report';
   [repOK, zerosOK] = et1gotest(Dev, 103); % 103 zeros are sent
   if local_warnET1report(repOK), return; end;
   if local_errorET1report(zerosOK), return; end;
   % 2. calibrate ET1 and PD1 clocks
   % assuming all is wired correctly, we don't need filters - the
   % sync-SS1 connects the PD1 directly to the ET1.
   if ~NoFullCalib, UIinfo('Calibrating ET1 clock...'); end;
   testType = 'clockCalib';
   s232('ET1clear',Dev);
   [PLAYinstr PD1pulseDist MaxEventTime, Npulse] = local_PreparePulsePlay(NoFullCalib);
   playit(PLAYinstr);
   % wait until D/A has finished
   while (s232('PD1status',1)~=0), end;
   s232('ET1stop',Dev);
   [RR N]= local_getET1events;
   if length(RR)<2,
      mess = strvcat('No pulses from PD1 detected', 'Check wiring');
      eh = errordlg(mess,'ET1  problems','modal');
      waitfor(eh);
      UIerror('ET1 problems');
      return;
   end;
   if length(RR)~=(Npulse+1), % +1 is the zero event from ET1go
      sizeRR = size(RR)
      Npulse
      % keyboard
      mess = strvcat('Incorrect number of pulses recorded', 'Check wiring');
      eh = errordlg(mess,'ET1 problems','modal');
      waitfor(eh);
      UIerror('ET1 problems');
      return;
   end;
   % check for hardware failure: RR should be non-descending
   if any(diff(RR)<0) | max(RR)>1.5*MaxEventTime,
      mess = strvcat('ET1 hardware/driver problems - unreliable time stamps', 'Check for IRQ conflicts');
      eh = errordlg(mess,'ET1 problems','modal');
      waitfor(eh);
      UIerror('ET1 problems');
      return;
   end;
   if NoFullCalib,
      success = 1;
      return;
   end
   % first event recorded is zero from ET1go; 2nd is synch pulse = reference time
   nfirst = 3; % this is where the true events start
   RR = RR(nfirst:end)-RR(2);
   % scale re PD1 pulse distance
   RR = RR/PD1pulseDist;
   % plot(RR,'x');
   coeff = polyfit(nfirst:N,RR,1);
   ET1pulseDist = coeff(1); 
   ClockRatio = 1/ET1pulseDist; % PD1 clock rate / ET1 clock rate
   global SGSR
   SGSR.ClockRatio = ClockRatio;
   success = 1;
   UIinfo('ET1 clock calibrated');
   LastTimeTested = clock;
catch
   disp(['error - ' lasterr]);
   dbstack;
   mess = strvcat('ET1 test/calibration failed', 'Check wiring', 'mMatLab mess:', lasterr);
   errordlg(mess);
   UIerror('ET1 failure');
   success = 0;
end


%----------locals-------------------------
function   [PLAYinstr, truePulseDist, maxEventTime, NpulsePlayed] = local_PreparePulsePlay(ShortOne);
% prepares left-channel pulse train using playit (just like stim menus)
% independent of system setup, a sample freq of 125 kHz is used
if ShortOne,
   trainRate = 375.6*2^0.5; % Hz; incommensurate with sample freq
   trainDur = 20; % ms
else,
   global SGSR
   trainDur = SGSR.ET1calibDur; % ms
   trainRate = 2000/(trainDur)*75.6*2^0.5; % Hz; incommensurate with sample freq
end
global SGSR GLBsync GLBsilence
SamP = s232('PD1speriod',1, 8);
dsamp = SamP-8;
Nsil = round(SGSR.switchDur/(SamP*1e-3));
[SilDBN SilREP] = silencelist(Nsil,1);
SyncDBN = GLBsync.DBN;
SyncREP = 1;
NtrainCycle = round(trainDur*1e-3*trainRate);
NsamPerTrainCycle = round(1/trainRate/(SamP*1e-6));
truePulseDist = NsamPerTrainCycle * SamP; % true distance between pulses in us
trainDBN = ml2dama([SGSR.TTLamplitude zeros(1,NsamPerTrainCycle-1)]);
trainREP = NtrainCycle;
DBNlist = [SyncDBN SilDBN.' trainDBN]; % row vector
REPlist = [SyncREP SilREP.' trainREP]; % idem
% playlist must be row vector with DBNs and REPs zipped + trailing zero
playList = [VectorZip(DBNlist, REPlist) 0];
% add fake second channel
playList = kron(playList,[1;0]);
% playList buffer must be large enough to contain playList
PlayListDBN = [ml2dama(playList(1,:)) 0];
chanDBN = ml2dama(PlayListDBN);
SampleLibDBNs = [];
Nplay = length(dama2ml(SyncDBN)) + Nsil + NsamPerTrainCycle*trainREP;
maxEventTime = 1e4+Nplay*SamP; % estimated maximum event time in us including pre-switch time of 100 ms (very large estimate)
NpulsePlayed = NtrainCycle+1; % synch pulse + train
PA4 = [1 99.9; 2 99.9];

Hardware = HardwareInstr4DA('L',1,Nplay,SamP);
Hardware.postGo = []; % don't switch to sound, but keep timing the events!

PLAYinstr = CollectInStruct(chanDBN, PlayListDBN, playList,SampleLibDBNs, ...
            Nplay, SamP, PA4, Hardware);


function DontContinue = local_warnET1report(repOK);
if repOK, DontContinue = 0; return; end;
message = strvcat('The ET1 doesn''t seem to function properly',...
   'The number of events reported is not equal to',...
   'the number of events recorded. This might result in',...
   'unreliable spike time recording. It might help to switch off',...
   'the power of the TDT racks and/or reboot the computer.',...
   'Also check for IRQ conflicts');
choice = warnchoice1('Event Timer warning',...
   'WARNING', message, 'Continue', 'Cancel');
DontContinue = ~isequal(choice, 'Continue');

function DontContinue = local_errorET1report(zerosOK);
if zerosOK, DontContinue = 0; return; end;
message = strvcat('The ET1 does not function properly.',...
   'It does not process ET1go commands correctly.',...
   'This will result in unreliable spike time recording.',...
   'It might help to switch off the power of the TDT racks',...
   'and/or reboot the computer.',...
   'Also check for IRQ conflicts');
choice = warnchoice1('Event Timer Error',...
   'ERROR', message, 'Ignore problem', 'Cancel');
DontContinue = ~isequal(choice, 'Ignore problem');

function [Events, N] = local_getET1events;
N = s232('ET1report',1); % assume # events from ET1report is correct
N = min(N,1e4); % ...but don't really trust it
Events = zeros(1,N);
for ii=1:N,
   Ev = s232('ET1read32',1);
   if Ev==-1,
      N = ii-1;
      Events = Events(1:N);
      break;
   else,
      Events(ii) = Ev;
   end
end







