function v = formatinfo(this,pre,wl,fl,extrastr)
%FORMATINFO   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(4,5,nargin,'struct'));

if nargin==4,
    extrastr = '';
end

if strcmpi(pre, 'u'),
    % Unsigned
    range = sprintf('[0 %d)',2^(wl-fl));
else
    % Signed
    range = sprintf('[-%d %d)',2^(wl-fl-1),2^(wl-fl-1));    
end

sep = ' -> ';

v = sprintf('%c%d,%d%s%s%s', pre, wl, fl, sep, range, extrastr);
    

% [EOF]
