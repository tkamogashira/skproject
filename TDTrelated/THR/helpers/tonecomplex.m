function T = tonecomplex(Amp, Freq, Ph0, Fsam, Dur);
%   tonecomplex - tone complex waveform
%   tonecomplex(Amp, Freq, Ph0, Fsam, Dur) returns the waveform of a tone
%   complex whose kth component has frequency Freq(k) Hz, linear amplitude 
%   Amp(k), and starting phase Ph0(k) cycles. A starting phase of zero 
%   corresponds to cosine phase. The waveform is sampled at Fsam in Hz and 
%   its duration is Dur ms. When specifying Ph0 = nan, tonecomplex returns
%   a matrix, each column representing a component as complex tone in zero
%   phase. This may be used to optimize the phases.
%
%   See also makestimZW, minimizetonecomplexpeaks.

doMatrix = isnan(Ph0);
N = [numel(Amp), numel(Freq), numel(Ph0)];
if doMatrix,
    if ~isequal(N(1), N(2)), error('#Amp values is unequal to # Freq values.'); end
else,
    if ~isscalar(unique(N)), error('#Amp values, # Freq values and # Phase values do not match.'); end
end
Nc = N(1); % # components
Nsam = round(Dur*Fsam/1e3); % # samples
Time = (0:Nsam-1).'/Fsam; % in s

if doMatrix,
    T = [];
    for icmp=1:Nc,
        cmp = Amp(icmp)*exp(2*pi*i*Freq(icmp)*Time);
        T = [T cmp];
    end
else,
    T = 0;
    phaseRad = 2*pi*Ph0;
    for icmp=1:Nc,
        cmp = Amp(icmp)*cos(phaseRad(icmp) + 2*pi*Freq(icmp)*Time);
        T = T + cmp;
    end
end














