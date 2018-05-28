function status = boardLED(LED, status);
% BoardLED - switch LEDS on board
%   boardLED(L,0) switches LED L off.
%   boardLED(L,1) switches LED L on.
%   L can be either a number, a character string or a char;
%   the naming of the 5 LEDs is as follows:
%       string     number   char
%       CENTRAL       0       C
%       UP            1       U
%       RIGHT         2       R
%       DOWN          3       L
%       LEFT          4       L
%   The central LED may alternatively be called FIX or F.
%   Multiple LEDs may be set by using a vector or cell string for L.
%
%   S = boardLED(L) returns the current status of LED(s) L without changing it/them.
%
%   See also InitBoardControl, FixLEDdelay.

if nargin<2, status = nan; end; % query
query = isnan(status);

if isnumeric(LED), ILED = 1+LED(:).'; % row vector;  +1 due to MatLab indexing
elseif iscell(LED), 
   st = [];
   for ii = 1:length(LED),
      st = [st boardLED(LED{ii}, status(min(end, ii)))];
   end
   status = st;
   return;
elseif ischar(LED),
   ILED = strmatch(upper(LED), {'CENTRAL' 'UP' 'RIGHT' 'DOWN' 'LEFT' 'FIX'});
   if isempty(ILED), 
      error(['Invalid LED specification ''' LED '''.']);
   end
   ILED = ILED(:).'; % row vector 
end
% ILED

% tag names of the respective LEDs as used in the RP2 circuit
LEDtag = {'LED_FIX', 'LED_UP', 'LED_RIGHT', 'LED_DOWN', 'LED_LEFT', 'LED_FIX'};

Dev = 'RP2_2';

if isnan(status), status = []; end;
lcount = 0;
for iled = ILED,
   lcount = lcount + 1;
   tag = LEDtag{iled};
   if query,
      status = [status, sys3getpar(tag, Dev)];
   else,
      st = status(min(end, lcount));
      sys3setpar(~st, tag, Dev); % ~st because logic high switch LED *off*
   end
end





