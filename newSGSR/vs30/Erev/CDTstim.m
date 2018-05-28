function CDTstim(Fcdt, Lbeat, N, DFstep, Fbeat, Dur, Ramp);
% CDTstim - generate stimuli for measurement of CDT cancellation phase
%   usage: CDTstim(Fcdt, Lbeat, N, DFstep, Fbeat, Dur, Ramp)
%   Input parameter as follows [default values]:
%     Fcdt:    frequency in Hz of CDT, must be ~CF of BM site
%     Lbeat:   level of cancellation tone in dB re primaries [-20 dB]
%     N:       # different primary spacings [40]
%     DFstep:  step in Hz of primary spacing [50 Hz]
%     Fbeat:   distance in Hz between CDT and cancellation tone [10 Hz]
%     Dur:     duration of stimulus in ms [300 ms]
%     Ramp:    duration of on and offset ramps in ms [2 ms]
%  
%   Sample rate of the waveforms is fixed at 200 kHz.
%
%   The user will be prompted for a filename, which is really
%   a prefix (e.g. xxx -> xxx01.dat, xxx02.dat ...). 
%   The waveforms are stored as 16-bit integers. 
%
%   EXAMPLES: 
%     CDTstim(15000) generates 40 waveforms with primary spacing 
%        varying between -+50*39/2 = +-975 Hz in steps of 50 Hz.
%     CDTstim(15000, -30) does the same except now the
%        cancellation tone is -30 dB below the closest primary
%        instead of the default value of -20 dB.

persistent DATdir; if isempty(DATdir), DATdir=[pwd '\']; end;
fsam = 200; % kHz sample rate
L2 = -10; % dB level of 2nd rpimary re first
maxDA = 30e3; % max magnitude of samples

if nargin<2, Lbeat = -20; end % dB beat/primary level
if nargin<3, N = 40; end % # primary spacings
if nargin<4, DFstep = 50; end % Hz step of primary spacing
if nargin<5, Fbeat = -10; end % Hz beat-CDT spacing
if nargin<6, Dur = 300; end % ms duration
if nargin<7, Ramp = 2; end % ms ramp dur

% get filename prefix from user; remember path for next call
[fn fp] = uiputfile(fullfile(DATdir, '*.dat'), ...
    'Specify filename prefix for waveform storage.');
if isequal(0,fn), return; end; % user cancelled
[DATdir FN] = fileparts([fp '\' fn]);
FN = fullfile(DATdir, FN);

% compute derived parameters
N = 2*ceil(N/2); % make sure to generate an even # of waveforms
DFmax = DFstep*(N-1)/2;
DF = linspace(-DFmax,DFmax,N); % primary spacing in Hz
F1 = Fcdt+DF; % freq of closest primary in Hz
F2 = Fcdt+2*DF; % freq of 2nd primary in Hz
Fc = Fcdt+Fbeat; % freq of cancellation tone in Hz
A2 = 10^(L2/20); % lin amp of 2nd primary re first
Ac = 10^(Lbeat/20); % lin amp of cancellation tone re 1st primary
Nramp = round(Ramp*fsam); % N samples in ramp
Rise = (sin(linspace(0,pi/2,Nramp)).^2).'; % window for onset ramp
Fall = flipUD(Rise); % idem offset ramp
Nsam = round(Dur*fsam); % # samples in each waveform
T2pi = 2*pi*(0:Nsam-1).'/(fsam*1e3); % 2 pi times time in seconds
Nrm = maxDA/(1+A2+Ac) ; % normalization factor to use full DA range

% compute waveforms and store them
for ii=1:N,
    w = cos(T2pi*F1(ii)) + A2*cos(T2pi*F2(ii)) + Ac*cos(T2pi*Fc);
    w(1:Nramp) = Rise.*w(1:Nramp);
    w(end-Nramp+1:end) = Fall.*w(end-Nramp+1:end);
    iistr = num2str(ii);
    if ii<10, iistr = ['0' iistr]; end
    Filename = [FN iistr '.dat']; % XX01.dat, XX02.dat ..
    [fid,mess] = fopen(Filename,'w'); error(mess);
    try, fwrite(fid, Nrm*w, 'int16');
    catch, fclose(fid); error(lasterr);
    end
    fclose(fid);
end









