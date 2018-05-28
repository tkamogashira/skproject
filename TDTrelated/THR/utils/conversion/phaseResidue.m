function R=phaseResidue(ph1, ph2,W)
% phaseResidue - sum of squared phase deviations
%    phaseResidue(PH1, PH2) returns the sum of squared phase deviations,
%    Sum(k)(Ph1(k)-Ph2(k)).^2, where Ph1 and Ph2 are phase vectors in cycles.
%    It is understood that the phases are circular, so that they may never
%    differ more than 0.5 cycle. PhaseResidue can be used to fit phase data
%    whose unwrapping is ambiguous.
%
%    phaseResidue(PH1, PH2, W) weights the phase differences with weight W,
%    i.e., it returns (Sum(k)W(k)(Ph1(k)-Ph2(k)).^2)/mean(W)
%
%
%    See also LinPhaseFit, unwrap, cunwrap, DelayPhase.

if nargin<3, W=1; end
D = mod(ph1-ph2,1); % phase difference in cycles; range is [0,1]
D = min(D,1-D); % always take shortest path along the circle
R = sum(W(:).*D(:).^2)/mean(W); % sum all elements, regardless of row/col organization

