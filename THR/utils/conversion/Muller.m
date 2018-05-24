function Y = Muller(X, flag);
% Muller - Muller's cochlear map for the gerbil
%    Muller(CF) returns cochlear distance in mm
%    from the apex for given CF in Hz, assuming 1 total BM length of 11 mm.
%
%    Muller(X, 'inverse') is the inverse function, returning the
%    CF in Hz of a given cochlear position X in mm from the apex.
%
%    See also Greenwood.

if nargin<2, flag=''; end

switch lower(flag),
case '', Inverse = 0;
case 'inverse', Inverse = 1;
otherwise,
   error(['Unknown option ''' flag '''.'])
end

L = 11; % total BM length
if Inverse,
   CD = X;
   Pos = 100*X/L; % position in % distance from apex
   CF = 398*(10.^(Pos*0.022)-0.631);
   Y = CF;
else,
   CF = X;
   % from Bram
   Pos = (1/0.022)*(log10(CF/398+0.631));
   Y = L*Pos/100;
end





