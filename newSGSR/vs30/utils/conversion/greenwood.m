function Y = greenwood(X, flag);
% Greenwood - Greenwood's cochlear map for the cat
%   Greenwood(CF) returns cochlear distance in mm
%   from the apex for given CF in Hz
%
%   Greenwood(X, 'inverse') is the inverse function, returning the
%   CF in Hz of a given cochlear position X in mm from the apex.

if nargin<2, flag=''; end

switch lower(flag),
case '', Inverse = 0;
case 'inverse', Inverse = 1;
otherwise,
   error(['Unknown option ''' flag '''.'])
end

if Inverse,
   CD = X;
   CF = 456*(10.^(0.084*CD)-0.8);
   Y = CF;
else,
   CF = X;
   % from Bram
   CD = (1/0.084)*(log10(CF/456+0.8)); %Greenwood-formula for cochlear distance ...
   Y = CD;
end





