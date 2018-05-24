function [out coeffnames variables] = mapcoeffstoports(this,varargin)
%MAPCOEFFSTOPORTS 

%   Copyright $ The MathWorks, Inc.

out = parse_mapcoeffstoports(this,varargin{:});

coeffnames = {'Num'};
idx = find(strcmpi(varargin,'CoeffNames'));
if ~isempty(idx),
    userdefinednames = varargin{idx+1}; 
    % if user-defined coefficient names are empty, return the default names.
    if ~isempty(userdefinednames)
        coeffnames = userdefinednames;
    end
end

if length(coeffnames)~=1,
    error(message('dsp:mfilt:abstractfirinterp:mapcoeffstoports:InvalidValue'));
end

% get numerator from polyphase
p = polyphase(this);
num = p(:);

% get fi properties
polym = this.privPolym(:);
if isfi(polym)
    T = numerictype(polym);
    F = fimath(polym);
    Num = fi(num,T,F);
else
    Num = num;
end

variables{1} = Num;


% [EOF]
