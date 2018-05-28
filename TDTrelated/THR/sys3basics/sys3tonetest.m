function sys3tonetest(Dev, Fsam, Amp, Freq);  
% sys3tonetest - test sys3 DAC by playing a tone
%   sys3tonetest('RX6', 80) plays a tone over the RX6's DAC channels 1 & 2
%   using a sample rate of ~80 kHz. Default device is RX6; default Fsam is
%   50 kHz.
%
%   sys3tonetest(Dev', Fsam, Amp, Freq) uses a peak amplitude of Amp volts
%   and a frequency of Freq Hz. Defaults 1 V; 1000 Hz.
%
%   Tone and/or amplitude may be arrays, in which case a tone complex is 
%   played. The maximum number of tones is five.


if nargin<1, Dev = 'RX6'; end
if nargin<2, Fsam = 50; end % ~50 kHz
if nargin<3, Amp = 1; end % 1 V
if nargin<4, Freq = 1000; end % Hz

[Amp, Freq] = samesize(Amp(:), Freq(:));
Ntone = numel(Amp);
if Ntone>5,
    error('Max # tones is two.');
end

sys3loadcircuit('tone_test', Dev, Fsam); 

for itone=1:Ntone,
    c = num2str(itone);
    sys3setpar(Amp(itone), ['Amp' c], Dev);
    sys3setpar(Freq(itone), ['Freq' c], Dev);
end

sys3run(Dev);
FreqStr = mat2str(Freq(:)');
AmpStr = mat2str(Amp(:)');
disp(['      Playing ' FreqStr '-Hz tone @ ' AmpStr ' V peak ... hit any key to stop.']);
pause
sys3halt(Dev);






