function [V, Ctype, R] = getValue(p, Unit);
% Parameter/getValue - getValue of Parameter in arbitrary units
%   P.value or getvalue(P) returns the value of a 
%   parameter object P in its proper units.
%
%   Getvalue(P, Unit) returns the value in the specified Unit.
%   Note: units are case sensitive!
%
%   [V, Quality, RelatedUnits] = Getvalue(P) also returns the type of the
%   physical quantity represented by P, e.g. 'frequency' and all
%   known related units, e.g. {'Hz' 'kHz' ...}.
%
%   See also Parameter/setValue and the documentation 
%   on Parameter objects.

% Note on implementation: the fake 'nan' units in each local function
% allow all units used by getValue to be queried. See isKnownUnit.

if nargin<2, Unit = ''; end

Unit = strSubst(Unit, '_', ' '); 
V = p.Value;

if ~isempty(Unit),
   if isequal(p.Unit, Unit), return; end % trivial conversion
   Ctype = '';
   switch p.Unit,
   case localConvert_frequency, Ctype = 'frequency';
   case localConvert_time, Ctype = 'time';
   case localConvert_phase, Ctype = 'phase';
   case localConvert_number, Ctype = 'number';
   case localConvert_DAchannel, Ctype = 'DAchannel';
   case localConvert_length, Ctype = 'length';
   case localConvert_temperature, Ctype = 'temperature';
   case localConvert_pitchInterval, Ctype = 'pitchinterval';
   case localConvert_switchState, Ctype = 'switchState';
   otherwise, error(['Cannot convert ''' p.Unit ''' to other units.']);
   end
   fnc = [ 'localConvert_' Ctype];
   try, 
      [R, V] = eval([fnc '(V, p.Unit, Unit);']); % no args - check for existence
   catch,  
      error(['Unknown ' Ctype ' unit ''' Unit '''.']);
   end
end

%------------------------------
function [knownUnits, X] = localConvert_frequency(X, FromUnit, ToUnit);
knownUnits = {'Hz' 'radps' 'degps'  'kHz' 'MHz' 'GHz'  'THz' 'nan'};
cFactor  =    [1   1./[2*pi   360]   1e3   1e6   1e9   1e12  nan];
if nargin<1, return; end;
ifrom = strmatch(FromUnit, knownUnits, 'exact');
ito = strmatch(ToUnit, knownUnits, 'exact');
if isempty(ito), error('ToUnit'); end
X = X*cFactor(ifrom)/cFactor(ito);

function [knownUnits, X] = localConvert_time(X, FromUnit, ToUnit);
knownUnits = {'fs'  'ps'   'ns'  'us'   'ms'   's'     'min' 'minute' 'h'  'day' 'week' 'nan'};
cFactor  =    [1e-18 1e-15 1e-12  1e-6  1e-3   1 cumprod([60  1       60   24    7      nan])];
if nargin<1, return; end;
ifrom = strmatch(FromUnit, knownUnits, 'exact');
ito = strmatch(ToUnit, knownUnits, 'exact');
X = X*cFactor(ifrom)/cFactor(ito);

function [knownUnits, X] = localConvert_phase(X, FromUnit, ToUnit);
knownUnits = {'cycle' 'deg' 'rad'  'nan'};
cFactor  =    [  1   1./[360  2*pi] nan];
if nargin<1, return; end;
ifrom = strmatch(FromUnit, knownUnits, 'exact');
ito = strmatch(ToUnit, knownUnits, 'exact');
X = X*cFactor(ifrom)/cFactor(ito);

function [knownUnits, X] = localConvert_number(X, FromUnit, ToUnit);
knownUnits = {'thousands' 'hundreds'  'dozen' 'tens'  'pair'  '1'  ' '  'tenth' '%'  'percent'  'cents'  'procent'   'promille'  'nan'};
cFactor  =    [ 1000          100        12     10       2      1    1    0.1   0.01   0.01      0.01      0.01         0.001     nan];
if nargin<1, return; end;
ifrom = strmatch(FromUnit, knownUnits, 'exact');
ito = strmatch(ToUnit, knownUnits, 'exact');
X = X*cFactor(ifrom)/cFactor(ito);

function [knownUnits, X] = localConvert_DAchannel(X, FromUnit, ToUnit);
knownUnits = fieldnames(DAchanNaming);
if nargin<1, return; end;
Xfrom = getfield(DAchanNaming, FromUnit);
if isequal('chanNum', FromUnit),
   Xfrom = [Xfrom{:}]; % numerical vector
   ifrom = find(X==Xfrom);
else,
   ifrom = strmatch(lower(X), lower(Xfrom), 'exact');
end
Xto = getfield(DAchanNaming, ToUnit);
X = Xto{ifrom};

function [knownUnits, X] = localConvert_switchState(X, FromUnit, ToUnit);
knownUnits = fieldnames(SwitchStateNaming);
if nargin<1, return; end;
Xfrom = getfield(SwitchStateNaming, FromUnit);
ifrom = strmatch(lower(X), lower(Xfrom), 'exact');
Xto = getfield(SwitchStateNaming, ToUnit);
X = Xto{ifrom};

function [knownUnits, X] = localConvert_length(X, FromUnit, ToUnit);
knownUnits = {'mile' 'km' 'm' 'yard'   'foot' 'feet' 'dm' 'inch'  'cm'              'mm'  'um' 'nm' 'pm' 'fm' 'nan'};
cFactor  =    [1609  1000 1   0.9144  0.3048*[1 1]   0.1  0.0254 0.01  cumprod(1e-3*[1     1    1    1    1])  nan];
if nargin<1, return; end;
ifrom = strmatch(FromUnit, knownUnits, 'exact');
ito = strmatch(ToUnit, knownUnits, 'exact');
X = X*cFactor(ifrom)/cFactor(ito);

function [knownUnits, X] = localConvert_temperature(X, FromUnit, ToUnit);
knownUnits = {'K'  'oC'     'oF'  'nan'};
cFactor  =  [  1     1        5/9  nan];
cOffset  =  [  0   273.15  255.3722]; % all offsets are in K
if nargin<1, return; end;
ifrom = strmatch(FromUnit, knownUnits, 'exact');
ito = strmatch(ToUnit, knownUnits, 'exact');
X = (X*cFactor(ifrom)+cOffset(ifrom)-cOffset(ito))/cFactor(ito);

function [knownUnits, X] = localConvert_pitchInterval(X, FromUnit, ToUnit);
knownUnits = {'octave' 'semitone' 'minor_third' 'major_third' 'fifth' 'nan'};
cFactor  =    [  12        1          3              4           7     nan];
if nargin<1, return; end;
ifrom = strmatch(FromUnit, knownUnits, 'exact');
ito = strmatch(ToUnit, knownUnits, 'exact');
X = X*cFactor(ifrom)/cFactor(ito);







