function modevalue=S2Init(Dn, Mode, Apt)

% function modevalue=S2Init(Dn, Mode, Apt)
% initializes AP2
%  ARG    DEFAULT    MEANING
%   Dn    {0}      selects logical device number
%   Mode  {1}      selects the application mode (see TDT's SISU guide)
%   Apt   {5000}   timeout in ms
% modevalue         0 if failed; Mode otherwise

if nargin<1, Dn=0; end;
if nargin<2, Mode=1; end;
if nargin<3, Apt=5000; end;

modevalue=s232('S2init', Dn, Mode, Apt);


