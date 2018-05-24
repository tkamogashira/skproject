function code = genmcode(this, Hd, prop, s)
%GENMCODE Generate MATLAB code 

%   Copyright 1999-2011 The MathWorks, Inc.

code = sigcodegen.mcodebuffer;

if nargin < 4,
    s = getsettings(this);
end

wordlength  = s.wordlength;
autoscale   = s.autoscale;
fraclengths = s.fraclengths;

info = qtoolinfo(Hd);

if isfield(info, prop)
    info = info.(prop);
else
    info.syncops = {prop};
end

prop(1) = upper(prop(1));

% If the current field is "autoscale" sync the autoscale.
if isfield(s, 'wordlength2') && ~isempty(s.wordlength2) && length(info.syncops) > 1 && ~isa(Hd,'dfilt.df1t')
    code.add('    ''%s'', %d, ...', [info.syncops{1} 'WordLength'], wordlength);
    code.cradd('    ''%s'', %d, ...', [info.syncops{2} 'WordLength'], s.wordlength2);
else
    code.add('    ''%s'', %d, ...', [prop 'WordLength'], wordlength);
end
switch lower(prop)
    case 'input'
        % NO OP.
    case 'output'
      if isprop(Hd,'OutputMode')
        if strcmpi(autoscale, 'off') 
            code.cradd('    ''OutputMode'', ''SpecifyPrecision'', ...');
        else
            code.cradd('    ''OutputMode'', ''AvoidOverflow'', ...');
        end
      end
    otherwise
        if strcmpi(this.AutoScaleAvailable, 'On'),
            if strcmpi(autoscale, 'on')
                as = 'true';
            else
                as = 'false';
            end
            code.cradd('    ''%s'', %s, ...', [prop 'AutoScale'], as);
        end
end

if strcmpi(autoscale, 'off'),
    if isempty(info.syncops)
        info.syncops = {prop};
    end
    for indx = 1:length(info.syncops)
        code.cradd('    ''%s'', %d, ...', [info.syncops{indx} 'FracLength'], fraclengths{indx});
    end
end

% [EOF]
