function ds = RAPds(Type)
%RAPDS  returns dataset currently loaded in the RAP session
%   ds = RAPDS or ds = RAPDS('FOREGROUND') returns the foreground 
%   dataset loaded in the RAP session. If no foreground dataset is
%   specified in the session or if there has not been an RAP session
%   during the current MATLAB execution, the empty vector is returned.
%
%   ds = RAPDS('BACKGROUND') returns the background dataset loaded
%   in the RAP session if one is present, else the empty vector is
%   returned.
%
%   See also RAP, RAPCMD

%B. Van de Sande 10-11-2004

if (nargin == 0)
    Type = 'foreground';
elseif (nargin ~= 1) || ~strncmpi(Type, {'f', 'b'}, 1)
    error('Wrong input argument.');
end

try
    ds = RAP(strncmpi(Type, 'b', 1) + 1); 
catch
    lasterror('reset');
    ds = [];
end