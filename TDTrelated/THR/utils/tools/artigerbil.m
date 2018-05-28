function artigerbil(CF,BW,NoiseAmp, Sens, Trefr, SpontRate);
% artigerbil - realtime gerbil disguised as an RP2.1
%    artigerbil(CF,BW,NoiseAmp, Sens, Trefr, SpontRate);
%    CF, BW in Hz
%    default: CF = 5000 Hz
%    default: BW = 150 Hz
%    default: NoiseAmp = 0.1;
%    default: Sens = 0.001;
%    default: Trefr = 0.1; % refractory period
%    default: SpontRate = 10 sp/s spontaneous rate

if nargin<1, CF= 5000; end
if nargin<2, BW= 150; end
if nargin<3, NoiseAmp= 0.1; end
if nargin<4, Sens = 0.001; end
if nargin<5, Trefr = 1; end % ms refractory time
if nargin<6, SpontRate = 10; end % sp/s spont rate

Dev = 'RX6_2'; Fsam = 50; % kHz
Fsam=sys3loadCircuit('ArtiGerbil', Dev, Fsam,0);
SpontRatePerSample = SpontRate/(Fsam*1e3); % prob for a spont spike per sample

% auditory filter
sys3setpar(20,'Gain',Dev);
sys3setpar(CF,'CF',Dev);
sys3setpar(BW,'BW',Dev);
sys3setpar(0.5-SpontRatePerSample,'genshift',Dev);

% spike
Spike = local_spike(Fsam,0.7);
SpikeDur = numel(Spike)/Fsam; % duration of spike in ms
sys3write(Spike,'SpikeWav',Dev);
sys3setpar(SpikeDur,'SpikeDur',Dev);
sys3setpar(NoiseAmp,'NoiseAmp',Dev);
sys3setpar(Sens,'Sens',Dev);
sys3setpar(max(0,Trefr-SpikeDur),'xRefr',Dev);

sys3run(Dev);

function W = local_spike(Fsam, DT);
dt = 1/Fsam;
Dur=5; T = linspace(0,5,round(Dur/dt));
W = spike_waveform(T,0.3,1,0.2, 2);
Nsam = round(DT/dt);
W = W(1:Nsam);





