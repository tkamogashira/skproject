function [x, inlog] = quantizeinput(q,x)
%QUANTIZEINPUT   

%   Author(s): V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

inlog = []; 
w = warning('off');

if strcmpi(class(x), 'double') || strcmpi(class(x), 'single'),
    x = validatedouble(x,q);
elseif strcmpi(class(x), 'embedded.fi'),
    x = validatefi(x,q);
elseif strncmpi(class(x), 'int', 3),
    x = validateint(x,q,'signed');
elseif strncmpi(class(x), 'uint', 4),
    x = validateint(x,q,'unsigned');
else
    error(message('dsp:quantum:abstractcicfilterq:quantizeinput:invalidDataType'));
end

f = fipref;
if strcmpi(f.LoggingMode, 'on'),
    % Fixed-point
    inlog = get(getqloggerstruct(x,0));
    inlog.Range = double(range(x));
    inlog.NOperations = prod(size(x));
    if ~isreal(x),
        inlog.NOperations = 2*inlog.NOperations;
    end
end
warning(w);

%--------------------------------------------------------------------------
function x = validatedouble(x,q)

% if q.InheritSettings,
%     error('dsp:quantum:abstractcicfilterq:quantizeinput:invalidDataType', ...
%         'Input can''t be of class double when InheritSettings is on.');
% end

% Create fi
inWL = q.InputWordLength;
inFL = q.InputFracLength;
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
x = fi(x, 'Signed', true, 'WordLength', inWL, 'FractionLength', inFL, 'fimath', F);

%--------------------------------------------------------------------------
function x = validatefi(x,q)

resetlog(x);
% if q.InheritSettings,
%     % Acquire settings
%     q.InputWordLength = x.WordLength;
%     q.InputFracLength = x.FractionLength;
% else
    inWL = q.InputWordLength;
    inFL = q.InputFracLength;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    x = fi(x, 'Signed', x.Signed, 'WordLength', inWL, 'FractionLength', inFL, 'fimath', F);
% end

%--------------------------------------------------------------------------
function x = validateint(x,q,signflag)

if strcmpi(signflag, 'Signed'),
    issigned = true;
    idx = 4;
else
    issigned = false;
    idx = 5;
end

% if q.InheritSettings,
%     xclass = class(x);
%     inWL = str2num(xclass(idx:end));
%     if ~issigned,
%         inWL = inWL+1;
%     end
%     % Acquire settings
%     q.InputWordLength = inWL;
%     q.InputFracLength = 0;
%     F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
%     x = fi(x, 'Signed', issigned, 'WordLength', inWL, 'FractionLength', 0, 'fimath', F);
% else
    inWL = q.InputWordLength;
    inFL = q.InputFracLength;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    x = fi(x, 'Signed', issigned, 'WordLength', inWL, 'FractionLength', inFL, 'fimath', F);
% end

% [EOF]
