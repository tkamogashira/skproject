function DAmode(Din, Mcode);

% function DAmode(Din, Mcode);
% XBUS DAmode, Din is devive number; Mcode is mode
% Default Din = 1
% Default Mcode = 3 = DUALDAC

if nargin<1, Din=1; end;
if nargin<2, Mcode=3; end;
s232('DAmode', Din, Mcode);
