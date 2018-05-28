function SPinfo = sing(Fsam, Dev);
% Sing - audio test using Seqplay functionality
%   sing(Fsam) plays a 12-tone tune over each DAC channel using
%   a sample rate of ~Fsam kHz. Default sample rate is 10 kHz.
%
%   sing(Fsam, Dev) uses TDT sys3 devive Dev; default Dev is RX6.

if nargin<2, Dev='RX6'; end

if nargin<1, Fsam=10; end
SPinfo = Seqplayinit(Fsam, Dev);
RampDur = 5; % ms
Amp = 1;

Fsam = SPinfo.Fsam; % kHz
Dur = 200; % ms
Nsam = round(Fsam*Dur);
NsamRamp = round(Fsam*RampDur);
ramp = linspace(0,1,NsamRamp);
tt = linspace(0,200,Nsam);
for ii=1:12,
   freq = 0.5*2^(ii/12);
   Nt = round(Nsam/2*(1+rand));
   tone = sin(2*pi*tt(1:Nt)*freq);
   tone(1:NsamRamp) = tone(1:NsamRamp).*ramp;
   tone(end+1-NsamRamp:end) = tone(end+1-NsamRamp:end).*flipLR(ramp);
   Tone{ii} = Amp*tone(:);
end

SPinfo = Seqplayupload(Tone,Tone);
LL = Seqplaylist(randperm(12), ones(1,12),randperm(12), ones(1,12));
%  monaural version
% SPinfo = Seqplayupload(Tone,{});
% LL = Seqplaylist(randperm(12), ones(1,12));
%LL = Seqplaylist(1:12, ones(1,12),1:12, ones(1,12));
Seqplaygo;





