function code = genmcode(this, Hd, prop, s)
%GENMCODE   Generate mcode

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

code = sigcodegen.mcodebuffer;

if nargin < 4,
    s = getsettings(this);
end

mode        = s.mode;
wordlength  = s.wordlength;
fraclengths = s.fraclengths;

info = qtoolinfo(Hd);
if isfield(info, prop)
    info = info.(prop);
else
    info.syncops = {prop};
end
if isempty(info)
    return;
end

prop(1) = upper(prop(1));

% Else sync the mode.
code.add('    ''%s'', ''%s'', ...', [prop 'Mode'], mode);
switch lower(mode)
    case {'keepmsb', 'keeplsb'}
        code.cradd('    ''%s'', %d, ...', [prop 'WordLength'], wordlength);
    case 'specifyprecision'
        code.cradd('    ''%s'', %d, ...', [prop 'WordLength'], wordlength);
        for indx = 1:length(info.syncops)
            code.cradd('    ''%s'', %d, ...', ...
                [info.syncops{indx} 'FracLength'], fraclengths{indx});
        end
    otherwise
        % NO OP.  Nothing else to set.
end

% [EOF]
