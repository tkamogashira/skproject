function transformfilter(hXT)
%TRANSFORM Perform the action of transforming the filter

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

xform  = get(hXT, 'Transform');
Hd     = get(hXT, 'Filter');

% Get the source and targe 
source = scaleAnswer(hXT, get(hXT, 'SourceFrequency'));
target = scaleAnswer(hXT, get(hXT, 'TargetFrequency'));

lbls = get(hXT, 'Labels');
lbls = lbls.(xform);
if ~strncmpi(xform, 'iirlp2mb', 8),
    target = target(1:length(lbls));
end

if strncmpi(xform, 'fir', 3),
    if findstr(hXT.TargetType, 'narrow'),
        type = {'narrow'};
    elseif findstr(hXT.TargetType, 'narrow'),
        type = {'wide'};
    else
        type = {};
    end
    Ht = feval(xform, Hd, type{:});
else
    
    % Get the filter and transform it
    Ht = feval(xform, Hd, source, target);
end

hXT.Filter = Ht;

send(hXT, 'FilterTransformed', ...
    sigdatatypes.sigeventdata(hXT, 'FilterTransformed', Ht));

set(hXT, 'isTransformed', 1);

    
%-------------------------------------------------------------------
function answer = scaleAnswer(hXT,answer)
% Scale answer back to normalized frequency

% Get frequency units from Fs
currentFs = get(hXT,'currentFs');

answer = evaluatevars(answer);
if iscell(answer), answer = [answer{:}]; end

if ~strcmpi(currentFs.units,'Normalized (0 to 1)'),
    answer = answer/(currentFs.value/2);
    if answer < 0 | answer > 1,
        error(message('dsp:fdtbxgui:xformtool:transformfilter:InvalidRange'));
    end
    
end

% [EOF]
