function FracWeight = FracCycleWeight(Phase, startPhase, Ncyc);
% FracCycleWeight - weight factors for correcting cycle histograms with fractional # cycles
%   w = FracCycleWeight(Phase, StartPhase, Ncyc) returns normalized vector of weights
%   to be applied to the elements of vector Phase. StartPhase is the
%   phase in cycles at the start of the analysis window, Ncyc the unrounded
%   number of cycles in the analysis window.

% makes sure that all phases are between 0 and 1
Phase = 1 + Phase - min(round(Phase));
startPhase = 1 + startPhase - min(round(startPhase));
Phase = rem(Phase,1);
startPhase = rem(startPhase,1);
endPhase = rem(startPhase+Ncyc,1);

if startPhase<endPhase,
   extra = 'mid';
   jumps = [startPhase, endPhase];
elseif startPhase>endPhase,
   extra = 'ends';
   jumps = [endPhase, startPhase];
else, extra='nope';
end

Nvisited = floor(Ncyc)*ones(size(Phase));
switch extra,
case 'mid'
   iextra = find((Phase>jumps(1)) & (Phase<=jumps(2)));
case 'ends'
   iextra = find((Phase<=jumps(1)) | (Phase>jumps(2)));
case 'nope'
   iextra = [];
end
Nvisited(iextra) = Nvisited(iextra) + 1;
FracWeight = 1./Nvisited; FracWeight = FracWeight/mean(FracWeight);

