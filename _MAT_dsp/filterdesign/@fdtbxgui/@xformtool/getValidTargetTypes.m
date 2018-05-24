function strs = getValidTargetTypes(this)
%GETVALIDTARGETTYPES Get the validTargetTypes.

%   Copyright 2006 The MathWorks, Inc.

source = get(this, 'SourceType');
if isempty(source)
    strs = {};
    return;
end

% Build up the target strings
switch lower(source)
case {'lowpass', 'highpass'},
    strs = {'Bandpass', ...
            'Bandstop', ...
            'Multiband', ...
            'Bandpass (complex)', ...
            'Bandstop (complex)', ...
            'Multiband (complex)', ...
        };
case {'bandpass', 'bandstop'},
    strs = {source};
end

switch lower(source)
case 'lowpass',
    strs = {'Lowpass', 'Highpass', strs{:}};
    oindx = 2;
    findx = 1;
case 'highpass',
    strs = {'Lowpass', 'Highpass', strs{:}};
    oindx = 1;
    findx = 4;
case {'bandpass', 'bandstop',}
    findx = 1;
end

filt = get(this, 'Filter');
if isempty(filt)
    return;
end

% If the filter can be transformed with FIR's, enable them
if isfir(filt) && islinphase(filt),
    ft = firtype(filt);
    if iscell(ft), ft = [ft{:}]; end
    if all(ft == 1),
        if length(strs) > 1,
            strs = {strs{1:oindx}, [strs{oindx} ' (FIR) wideband'], strs{oindx+1:end}};
            strs = {strs{1:oindx}, [strs{oindx} ' (FIR) narrowband'], strs{oindx+1:end}};
        end
        strs = {strs{1:findx} [strs{findx} ' (FIR)'] strs{findx+1:end}};
    end
end

% [EOF]
