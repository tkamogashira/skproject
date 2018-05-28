function [iku, Q, R] = isKnownUnit(U);
% isKnownUnit - true if a unit is a known parameter unit
%    isKnownUnit(unitString) returns 1 if a parameter unit is known,
%    i.e., parameter/getValue can convert it to other units.
%
%   [yn, Quality, RelatedUnits] = isKnownUnit(U) also returns the 
%   Quality of the physical quantity expressed by units U, e.g. 'frequency' 
%   for U = 'Hz'. A question mark is returned for unknown units.
%   RelatedUnits is a char cell array containing all known units of
%   expressing the same Quality.
%   
%   See also Parameter/getValue, parameter.

% first generate a parameter with the putative unit U.
% Use hack to circumvent value testing by any parameter interpreter.
testPar = parameter('TEST 1 _');
testPar = struct(testPar);
testPar.Unit = U;
testPar = parameter(testPar);
iku = 1;
try, [dum, Q, R] = getvalue(testPar, 'nan'); % fake conversion fails if unit is not known
catch, 
   iku = 0;
   Q = '?';
   R = {''};
end




