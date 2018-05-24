function [F, mess] = UnitConvert(U1,U2);
%  UnitConvert - conversion factors for change of units
%     UNITCONVERT('U1','U2') returns the factor that converts
%     X1 to X2 when X1 and X2 are expressed in 'U1' and 'U2'
%     units, repectively. E.g, UNITCONVERT('ms', 'us') returns 1000 
%     because T ms is equivalent to 1000 T us.
%
%     Units are case sensitive, e.g., 'Ms' != 'ms'
%     Unknown and incompatible units produce an error message.
%
%     The syntax [F MESS] = UNITCONVERT(U1,U2) suppresses the error
%     and returns the error message in MESS.
%     
%     See also MLsig/XUNIT.

error(nargchk(2,2,nargin));
mess = ''; F = nan;
[Q1, F1] = local_quant(U1);
[Q2, F2] = local_quant(U2);
if isnan(F1), mess = ['unknown unit ''' U1 ''''];
elseif isnan(F2), mess = ['unknown unit ''' U2 ''''];
elseif ~isequal(Q1,Q2), mess = ['incompatible units ''' U1 ''' and ''' U2 '''.'];
else, F = F1/F2;
end

%--------------------
function [q, absfac]=local_quant(u);
timeUnits = {'s', 'ms', 'us', 'ns', 'ps', 'fs'};
freqUnits = {'Hz', 'kHz', 'MHz'};
phaseUnits = {'rad' 'radians', 'cycles', 'cycle', 'degrees', 'degree', 'deg'};
switch u,
case timeUnits,
   q = 'time';
   if isequal(u,'s'), u='1s'; end
   index = findstr(u,['1' cat(2,timeUnits{:})]);
   absfac = 10^(-(3*(index-1)/2));
case freqUnits,
   q = 'freq';
   if isequal(u,'Hz'), u='1Hz'; end
   index = findstr(u,['1' cat(2,freqUnits{:})]);
   absfac = 10^(3*(index-1)/3);
case phaseUnits,
    q = 'phase';
    switch u,
        case {'radians', 'rad'}
            absfac = 1/(2*pi);
        case {'degrees', 'deg', 'degree'}
            absfac = 1/360;
        case {'cycles' 'cycle'},
            absfac = 1;
        otherwise
            absfac = nan;
    end
otherwise,
   q = '';
   absfac = NaN;
end




