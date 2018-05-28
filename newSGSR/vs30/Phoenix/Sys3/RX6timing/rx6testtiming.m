function [Lag, Measurement] = RX6testTiming(pulseRate, pulseDur);
% RX6testTiming - test relative timing of timestamps and DAC in RX6
%   The coil is switched, TTL pulses are played back at Out-1 and detected 
%   at DIO1, timestamps are set, and the coil is switched back.
%   
%   Purpose of this function is to detect the relative time difference 
%   between Out-1 and DIO1.
%
%   Lag = RX6testTiming(pulseRate, pulseDur)
%
%   pulseRate (Hz) indicates the rate at which pulses should be played
%   pulseDur (us) indicates the duration of each pulse
%   Defaults are respectively 200 Hz and 500 us.
%
%   Lag indicates the relative time difference between Out-1 and DIO1.


% ======================= DEFAULTS ===========================================================%

if nargin<1, pulseRate  = 200; end % Hz 
if nargin<2, pulseDur   = 500; end % us

SPinfo  = RX6seqplayInit('status');
Fsam    = SPinfo.Fsam; % exact sample rate in kHz
Dev     = SPinfo.Dev;


% ======================= PULSE PROPERTIES ===================================================%

prePot      = -3;   % V prepotential
maxTTL      = 9.5;  % V peak of synthesized TTL pulse
Npulse      = 31;   % # pulses in train; 
NPrepulse   = 5;    % pre- and post time (in pulse periods) to settle neg prepotential and to suppress spurious stamping
Nignore     = 0;    % # first Nignore are not used for calibration (their timing is off)


% ======================= SYNTHESIZE PULSE ===================================================%

pulsePeriod = 1e6/pulseRate; 

Nup     = max(1,round(Fsam*1e-3*pulseDur)); % one sample is minimum ..
Nper    = round(Fsam*1e-3*pulsePeriod);
Nrem    = Nper-Nup;

pulse   = [maxTTL*ones(Nup,1); prePot*ones(Nrem,1)];

% exact pulse rate is affected by # samples
pulseRate   = 1e3*Fsam/length(pulse); % true pulse rate in Hz
pulseDur    = 1e3/pulseRate; % true pulse duration in ms

NsamPrepulse    = NPrepulse*Nper; % # samples in prepulse
prepulse        = ones(NsamPrepulse,1)*prePot;
Pretime         = NPrepulse*pulseDur; % time after which pulses start

PulseEndTime    = Pretime + Npulse*pulseDur; % time after which pulses end

detectWindow    = [Pretime PulseEndTime+0.5*Pretime]; % window in ms for true, nonspurious, pulses 


% ======================= PREPARE D/A CONVERSION =============================================%

RX6seqplayhalt;

% pause(1)
RX6seqplayUpload({prepulse, pulse}, {}); 
% pause(1)
RX6seqplayList([1 2 1], [1 Npulse 1]); 
% pause(1)

% calib real
sys3setpar(1,'CalibRelay',Dev);
pause(0.2);


% ======================= D/A CONVERSION ====================================================%

% play pulse train
RX6seqplayGO;

% wait for D/A to finish
while RX6seqplayStatus('L'), pause(0.05); end

% reset calib relay
sys3setpar(0,'CalibRelay',Dev);

%  RX6seqplayreview('L')
% set(gcf,'pos', [ 411   299   572   382])


% ======================= PROCESS EVENT TIMES ===============================================%

% get event times
[EventTime, N] = RX6getStamps; % in ms

% filter out the spurious events
iok = find(EventTime>detectWindow(1) & EventTime<detectWindow(2)); % within proper time window
EventTime = EventTime(iok);
N = length(EventTime);

iring = find(diff(EventTime)<0.5*pulseDur); % indices of "ringing events"
EventTime(iring+1) = [];

% discard very first event as its timing seems alays to be too early by ~ 1us
EventTime = EventTime((1+Nignore):end);

% compare measured event times and computed ones
properTime = Pretime + 1e3*(Nignore:N-1)/pulseRate; % theoretical timing of pulses in ms (note omitting of first Nignore pulses)

if ~isequal(N,Npulse),
   error('# pulses detected is different from # pulses played.');
end

Coeff = polyfit(properTime, EventTime,1);
Slope = Coeff(1); Dslope = Slope-1;
Intercept = Coeff(2);

Lag = mean(EventTime-properTime); % in ms
LagSam = Lag*Fsam; % lag in samples

DTevent = diff(EventTime)/mean(diff(properTime));
MeanDist = mean(DTevent);
STD_Dist = std(DTevent);

Measurement = collectInStruct(properTime, EventTime, N, Fsam, Intercept, Slope, Dslope, DTevent, MeanDist, STD_Dist, Lag, LagSam);

disp('=======================================');
disp(['sample rate: ' num2str(Fsam) ' kHz']);
disp([num2str(N) '/' num2str(Npulse) ' pulses detected' ]);
disp(['Lag of time stamped DAC pulses re proper time: ' num2str(deciround(Lag,7),6)  ' ms = ' num2str(LagSam,6) ' samples']);
disp('=======================================');


