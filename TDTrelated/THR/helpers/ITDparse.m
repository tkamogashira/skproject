function [Fine, Gate, Mod] = ITDparse(ITD, ITDstring); 
% ITDparse - parse ITD-describing string
%    [Fine, Gate, Mod] = ITDparse(ITD, ITDstring) interprets an ITD in terms of
%    its different participants. ITDstring is a char string describing the
%    type of ITD. Fine, Gate and Mod are the values of ITD imposed on the
%    waveform fine structure, the gating and the modulation, respectively.
%    The following table describes the assigment of the different types of
%    ITDs (quotes are omitted).
%
%     ITDstring      |      Fine      Gate      Mod
%    ------------------------------------------------
%       waveform     |      ITD       ITD       ITD
%       fine         |      ITD        0         0 
%       gate         |       0        ITD        0 
%       mod          |       0         0        ITD
%       fine+gate    |      ITD       ITD        0 
%       fine+mod     |      ITD        0        ITD
%       gate+mod     |       0        ITD       ITD
%       fine<=>gate  |      ITD      -ITD        0 
%       fine<=>mod   |      ITD        0       -ITD
%       gate<=>mod   |       0        ITD      -ITD
%    ------------------------------------------------
%
%    ITD may be an array. 
%
%    See also ToneStim.

ITDstring = lower(ITDstring);

% for backward compatibility, convert older specs to newer ones
if isequal('ongoing', ITDstring),
    ITDstring = 'fine';
elseif isequal('gating', ITDstring),
    ITDstring = 'gate';
end

switch ITDstring,
    case 'waveform',    W = [1 1 1];
    case 'fine',        W = [1 0 0];
    case 'gate',        W = [0 1 0];
    case 'mod',         W = [0 0 1];

    case 'fine+gate',   W = [1 1 0];
    case 'fine+mod',    W = [1 0 1];
    case 'gate+mod',    W = [0 1 1];
    
    case 'fine<=>gate',   W = [1 -1 0];
    case 'fine<=>mod',    W = [1 0 -1];
    case 'gate<=>mod',    W = [0 1 -1];
    
    otherwise,
        error(['Invalid ITDtype string ''' ITDstring '''.']);
end

Sz = size(ITD);
ITD = ITD(:)*W;
Fine = reshape(ITD(:,1), Sz);
Gate = reshape(ITD(:,2), Sz);
Mod = reshape(ITD(:,3), Sz);




