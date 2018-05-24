function disp(h, spacing)
%DISP Object display.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if nargin < 2
    spacing = 20;
end

s = get(h);

% Re-order properties
if h.CoeffAutoScale,
    coeffprop = {'CoeffWordLength';...
        'CoeffAutoScale';...
        'Signed'};
else
    coeffprop = {'CoeffWordLength';...
        'CoeffAutoScale';...
        'NumFracLength';...
        'Signed'};
end

inprop = {'InputWordLength';...
    'InputFracLength'};

internalsprop = {'FilterInternals'};

str = [];

if strcmpi(get(0, 'formatspacing'), 'loose')
    spacer = ' ';
else
    spacer = '';
end

if strcmpi(h.FilterInternals,'SpecifyPrecision'),
    outprop = {'OutputWordLength',...
        'OutputFracLength'};
    modes = {'RoundMode',...
        'OverflowMode'};
    prodprop = {'ProductWordLength';...
        'ProductFracLength'};
    accprop = {'AccumWordLength';...
        'AccumFracLength'};

    str = strvcat(str, dispstr(coeffprop,h,spacing), ...
        spacer, dispstr(inprop,h,spacing), ...
        spacer, dispstr(internalsprop,h,spacing), ...
        spacer, dispstr(outprop,h,spacing), ...
        spacer, dispstr(prodprop,h,spacing), ...
        spacer, dispstr(accprop,h,spacing), ...
        spacer, dispstr(modes,h,spacing), spacer);
else
    str = strvcat(str, dispstr(coeffprop,h,spacing), ...
        spacer, dispstr(inprop,h,spacing), ...
        spacer, dispstr(internalsprop,h,spacing), spacer);
end

disp(str)

%--------------------------------------------------------------------------
function str = dispstr(propnames,h, spacing)

str = [];
for i=1:length(propnames),
    q=h.(propnames{i});
    whites = spacing-length(propnames{i});
    whites = sprintf(['%-',sprintf('%d',whites),'s'], ' ');
    str = strvcat(str, [whites, propnames{i}, qstrh(q)]);
end


%--------------------------------------------------------------------------
function str = qstrh(q)

% Get the quantizer info
if ischar(q),
    str = [': ''' q ''''];
elseif islogical(q),
    if q,
        str = [': true'];
    else
        str = [': false'];
    end
else
    str = sprintf(': %d', q);
end
