function str = genmcode(hObj)
%GENMCODE Generate Matlab-code

%   Copyright 1999-2011 The MathWorks, Inc.

str = sigcodegen.mcodebuffer;

xform  = get(hObj, 'Transform');

comment = sprintf('%% Convert the %s filter to a %s filter.', get(hObj, 'SourceType'), ...
            get(hObj, 'TargetType'));

if strncmpi(xform, 'fir', 3),
    if findstr(hObj.TargetType, 'narrow'),
        optstr = ', ''narrow''';
    elseif findstr(hObj.TargetType, 'narrow'),
        optstr = ', ''wide''';
    else
        optstr = '';
    end
    
    str.addcr(comment);
    str.addcr('Hd = %s(Hd%s);', xform, optstr);
else

    source = get(hObj, 'SourceFrequency');
    target = get(hObj, 'TargetFrequency');
    lbls = get(hObj, 'Labels');
    lbls = lbls.(xform);
    if ~strncmpi(xform, 'iirlp2mb', 8),
        target = target(1:length(lbls));
    end
    
    params = {'Fo', 'Ft'};
    values = {num2str(source), lclnum2str(target)};
    
    fs = get(hObj, 'CurrentFs');
    if strncmpi(fs.units, 'n', 1)
        fs = '';
    else
        str.addcr('%% Frequency Units in %s', fs.units);
        params = {'Fs', params{:}}; %#ok<*CCAT>
        values = {num2str(fs.value), values{:}};
        fs = '/(Fs/2)';
    end
    
    str.addcr(str.formatparams(params, values));
    
    str.cr;
    str.addcr(comment);
    str.addcr('Hd = %s(Hd, Fo%s, Ft%s);', xform, fs, fs);
end

% ------------------------------------------------------------------
function v = lclnum2str(v)

if length(v) == 1,
    v = num2str(v{1});
else
    
    for indx = 1:length(v)
        v{indx} = [num2str(v{indx}) ' '];
    end
    
    v = ['[' deblank([v{:}]) ']'];
end

% [EOF]
