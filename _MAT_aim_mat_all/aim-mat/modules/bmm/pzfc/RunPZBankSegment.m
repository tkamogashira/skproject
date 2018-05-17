function [outarray, prevout, agcstate, state1, state2, pdampsmod] = ...
    RunPZBankSegment(inputSegment, prevout, agcstate, state1, state2, pfreqs, pdamps, pdampsmod, ...
    mindamp, maxdamp, xmin, xmax, rmin, rmax, za0, za1, za2, agcepsilons, agcgains, agcfactor, doagcstep, doplot)
% function [outarray, prevout, agcstate, state1, state2, pdampsmod] = ...
%     RunPZBankSegment(inputSegment, prevout, agcstate, state1, state2, pfreqs, pdamps, pdampsmod, ...
%     mindamp, maxdamp, xmin, xmax, rmin, rmax, za0, za1, za2, agcepsilons, agcgains)

if nargin < 21
       doagcstep = 1;
end

[Nt, Ntracks] = size(inputSegment);

Nch = length(pfreqs);

if nargin < 22
    doplot = 0;
end

if doplot ~= 0
  figa = 13;
  figb = 14;
else
  figa = 0; %don't plot
  figb = 0; % don't plot
end

for t = 1:Nt

    inputs = [inputSegment(t,:); prevout(1:Nch-1,:)];

    [outputs state1 state2] = PZBankStep2(inputs, pfreqs, pdampsmod, ...
        mindamp, maxdamp, xmin, xmax, rmin, rmax, za0, za1, za2, state1, state2, figa, figb);

    % differential velocity detection:
    %detect = DetectFun(outputs-prevout);
    detect = DetectFun(outputs);
    
    if doagcstep ==1
        [pdampsmod agcstate] = AGCdampStep(detect, pdamps, agcepsilons, agcgains, agcstate, agcfactor);
    end

    %outarray(:,t) = detect(:); % flatten Ntracks columns into one
    outarray(:,t)=outputs(:); % no rectification.
    prevout = outputs;
    
    figa = 0;
    figb = 0;
    
end

return;
