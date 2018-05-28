function [bestPhase, W] = minimizetonecomplexpeaks(W);
% minimizetonecomplexpeaks - minimize sample magnitude of tone complex
%    [Ph, W] = minimizetonecomplexpeaks(W) attempts to reduce the maximum
%    sample magnitude of a tone complex by varying the relative phases of
%    its components. The input is a complex tone complex matrix as returned
%    by tonecomplex (using Ph0=nan). The outputs Ph and W are the optmal
%    phases [cycles] and resulting complex waveform, respectively.
%
%    See also tonecomplex.

NtestPhase = 128; % # of phase values for rotating each component
Nrun = 10;

Nc = size(W,2); % # components

bestPhase = zeros(1,Nc);
testPhase = (0:NtestPhase-1)/NtestPhase;
Phasor = exp(2*pi*i*testPhase);
for irun = 1:Nrun
    for icmp=2:Nc,
        bph = 0;
        for itest=1:NtestPhase,
            w = W;
            w(:,icmp) = w(:,icmp)*Phasor(itest);
            MaxMag(itest) = max(abs(sum(w,2)));
        end
        [dum, ibest] = min(MaxMag);
        bestPhase(icmp) = bestPhase(icmp) + testPhase(ibest);
        W(:,icmp) = W(:,icmp)*Phasor(ibest);
    end
end










